{
  system = "x86_64-linux";
  username = "ash";
  homeDirectory = "/home/ash";
  stateVersion = "21.05";
  configuration = { lib, pkgs, ... }: {
    imports = [
      ../common
      ./fonts.nix
      ./nix.nix
      ./programs
      ./rs
      ./scripts
      ./theme.nix
      ./xdg.nix
    ];

    programs.home-manager.enable = true;

    # https://moritzmolch.com/blog/1749.html, https://docs.xfce.org/xfce/tumbler/available_plugins
    # note: apparently xcftools is unmaintained since 2019 and nixpkgs' version has multiple code-execution vulnerabilities, so let's not use xcf2png
    xdg.dataFile."thumbnailers/xcf.thumbnailer".text = ''
      [Thumbnailer Entry]
      TryExec=${pkgs.imagemagick}/bin/convert
      Exec=${pkgs.imagemagick}/bin/convert xcf:%i -flatten -scale 512x%s png:%o
      MimeType=image/x-xcf;
    '';

    systemd.user.targets = {
      # Workaround for "Unit tray.target not found" when starting e.g. flameshot
      # https://github.com/nix-community/home-manager/issues/2064
      tray = {
        Unit = {
          Description = "Fake tray target (workaround for home-manager problem)";
          Requires = [ "graphical-session-pre.target" ];
        };
      };
    };
    systemd.user.timers = {
      empty-trash = {
        Unit = {
          Description = "Regularly delete old trashed files";
          PartOf = [ "empty-trash.service" ];
        };
        Timer = {
          OnStartupSec = 60 * 60; # 1 hour after login
          OnUnitActiveSec = 60 * 60 * 24; # every 24 hours thereafter
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
    systemd.user.services = {
      empty-trash = {
        Unit = {
          Description = "Delete old trashed files";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.trash-cli}/bin/trash-empty 28"; # delete files more than 28 days old
        };
      };
    };
  };
}
