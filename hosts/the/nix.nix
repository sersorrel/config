{ inputs, lib, ... }:

let
  channelPaths = let
    base = "/etc/nixpkgs/channels";
  in {
    nixpkgs = "${base}/nixpkgs";
    nixpkgs-unstable = "${base}/nixpkgs-unstable";
    home-manager = "${base}/home-manager";
  };
in
{
  nix = {
    settings.cores = 3; # cores per build
    settings.max-jobs = 3; # simultaneous builds
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.keep-outputs = true; # non-garbage derivations keep all their outputs alive
    settings.connect-timeout = 10; # seconds to try connecting to each binary cache
    settings.log-lines = 20; # lines displayed after a build failure
    settings.auto-optimise-store = true; # automatically hardlink store files
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
        "steam-run"
        "tixati"
      ];
    };
    # TODO: https://nixos.wiki/wiki/Overlays#Using_nixpkgs.overlays_from_configuration.nix_as_.3Cnixpkgs-overlays.3E_in_your_NIX_PATH
    overlays = [
      (self: super: {
        fishPlugins = super.fishPlugins.overrideScope' (self': super': let
          meta = {
            pname = "fenv.rs";
            version = "unstable-2022-10-28";
            src = super.fetchFromGitHub {
              owner = "sersorrel";
              repo = "fenv.rs";
              rev = "c3fba45c9d86f2177d3b698bede4e6476c2a2bd7";
              sha256 = "01i44rmi99wjrggd6r99qpnmclxdjllgxl73kl06vx7p29hzgsx6";
            };
          };
          fenv = super.rustPlatform.buildRustPackage {
            inherit (meta) pname version src;
            cargoSha256 = "0isq1niw5yw8ycvqkvs2l10jww6k5mpmwzyr2ag57imcfw8s1pik";
          };
        in {
          foreign-env = super'.buildFishPlugin {
            inherit (meta) pname version src;
            preInstall = ''
              sed -i 's|_fenv|${fenv}/bin/_fenv|g' functions/fenv.fish
            '';
          };
        });
      })
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
          src = assert super.lib.versionOlder super.i3.version "4.22.0"; super.fetchFromGitHub {
            owner = "i3";
            repo = "i3";
            rev = "30131ed69795387ddc576b5dab24b5649e5b8583";
            sha256 = "13jwjbb9vcqavg6dy6fk99vxbh7kfya56a0m5c6h3z12nkrd5030";
          };
          patches = (old.patches or []) ++ [
            ./patches/i3-0001-i3bar-border.patch
          ];
        });
      })
    ];
  };
  systemd.tmpfiles.rules = lib.mapAttrsToList (name: value: "L+ ${value} - - - - ${inputs.${name}}") channelPaths;
}
