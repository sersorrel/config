{ inputs, lib, ... }:

let
  channelPaths = let
    base = "/etc/nixpkgs/channels";
  in {
    nixpkgs = "${base}/nixpkgs";
    nixpkgs-unstable = "${base}/nixpkgs-unstable";
  };
in
{
  nix = {
    buildCores = 3; # cores per build
    maxJobs = 3; # simultaneous builds
    settings.experimental-features = [ "nix-command" "flakes" ];
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    };
    # https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798/2
    # see also systemd.tmpfiles.rules below
    nixPath = lib.mapAttrsToList (name: value: "${name}=${value}") channelPaths;
  };
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "brgenml1lpr"
        "cudatoolkit"
        "google-chrome"
        "nvidia-settings"
        "nvidia-x11"
        "steam"
        "steam-original"
        "tixati"
      ];
    };
    # TODO: https://nixos.wiki/wiki/Overlays#Using_nixpkgs.overlays_from_configuration.nix_as_.3Cnixpkgs-overlays.3E_in_your_NIX_PATH
    overlays = [
      (self: super: {
        i3lock-color = super.i3lock-color.overrideAttrs (old: {
          src = self.fetchFromGitHub {
            owner = "sersorrel";
            repo = "i3lock-color";
            rev = "8ab09b8d3fdd87ac0b14a3f419281a4791fa2c78";
            sha256 = "1l25x4wx3ar6lfpxcm5whzpxyblcs8blf4gqi3vh2ynvn7cn1qib";
          };
        });
      })
      (self: super: {
        gnome = super.gnome.overrideScope' (self': super': {
          gnome-power-manager = super'.gnome-power-manager.overrideAttrs (old: {
            patches = (old.patches or []) ++ [
              ./patches/gnome-power-manager-0001-desktop-entry.patch
            ];
          });
        });
        i3 = super.i3.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            ./patches/i3-0001-i3bar-border.patch
          ];
        });
      })
    ];
  };
  systemd.tmpfiles.rules = lib.mapAttrsToList (name: value: "L+ ${value} - - - - ${inputs.${name}}") channelPaths;
}
