{
  system = "x86_64-linux";
  username = "ash";
  homeDirectory = "/home/ash";
  stateVersion = "21.05";
  configuration = { lib, pkgs, ... }: {
    imports = [
      ./fonts.nix
      ./nix.nix
      ./programs
      ./rs
      ./scripts
      ./theme.nix
      ./xdg.nix
    ];

    programs.home-manager.enable = true;

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
