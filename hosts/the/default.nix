{
  system = "x86_64-linux";
  modules = [({ pkgs, lib, secrets, ... }: {
    imports = [
      ./applications.nix
      ./bluetooth.nix
      ./borg.nix
      ./filesystems.nix
      ./graphics.nix
      ./hardware-configuration.nix
      ./input.nix
      ./iotop.nix
      ./jupyter
      ./lxd.nix
      ./networking.nix
      ./nintendo-controllers.nix
      ./nix.nix
      ./printing.nix
      ./samba.nix
      ./sound.nix
      ./tixati.nix
      ./xorg.nix
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Currently ~/.profile isn't sourced in graphical sessions, let's fix that.
    # https://github.com/NixOS/nixpkgs/issues/5200
    # This can be removed in 22.11: https://github.com/NixOS/nixpkgs/pull/185987
    environment.loginShellInit = ''
      if test -f ~/.profile; then
        . ~/.profile
      fi
    '';

    hardware.cpu.intel.updateMicrocode = true;

    i18n.defaultLocale = "en_GB.UTF-8";

    networking.hostName = "the";
    networking.firewall = {
      allowedTCPPorts = [
        22000 # Syncthing
      ];
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
      allowedUDPPorts = [
        22000 21027 # Syncthing
      ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
    };

    # Turn any attached Launchpad off/on on suspend/resume.
    powerManagement.powerDownCommands = ''
      launchpad_port=$(${pkgs.alsa-utils}/bin/amidi -l | ${pkgs.gawk}/bin/awk '/Launchpad Mini MK3 LPMiniMK3 MI/ { print $2 }')
      test -n "$launchpad_port" && ${pkgs.alsa-utils}/bin/amidi -p "$launchpad_port" -S "F000 20 29 02 0D 09 00 F7"
    '';
    powerManagement.powerUpCommands = ''
      launchpad_port=$(${pkgs.alsa-utils}/bin/amidi -l | ${pkgs.gawk}/bin/awk '/Launchpad Mini MK3 LPMiniMK3 MI/ { print $2 }')
      test -n "$launchpad_port" && ${pkgs.alsa-utils}/bin/amidi -p "$launchpad_port" -S "F000 20 29 02 0D 09 01 F7"
    '';

    # Stop the sudo prompt timing out.
    security.sudo.extraConfig = ''
      Defaults passwd_timeout=0
    '';

    services.logind.lidSwitchDocked = "suspend";

    time.timeZone = "Europe/London";

    programs.nix-ld.enable = true;

    users = {
      mutableUsers = false;
      users.ash = {
        isNormalUser = true;
        extraGroups = [
          "adbusers"
          "colord"
          "dialout"
          "lxd"
          "networkmanager"
          "wheel"
          "wireshark"
        ];
        shell = pkgs.fish;
        passwordFile = secrets.my.passwordFile; # remember to set neededForBoot on the relevant mountpoint
      };
    };

    system.stateVersion = "21.05";
  })];
}
