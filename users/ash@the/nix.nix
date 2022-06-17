{ inputs, pkgs, ... }:

{
  nix.registry = {
    user-nixpkgs.flake = inputs.nixpkgs;
    user-nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    secrets.to = { type = "path"; path = toString ~/Secrets; };
  };

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  nixpkgs.overlays = import ./nixpkgs-overlays.nix { unstable = import inputs.nixpkgs-unstable { system = "x86_64-linux"; }; };
  xdg.configFile."nixpkgs/overlays.nix".text = let
    raw = builtins.readFile ./nixpkgs-overlays.nix;
    prefix = "{ unstable }:\n";
    processed = assert pkgs.lib.hasPrefix prefix raw; pkgs.lib.removePrefix prefix raw;
  in ''
    let unstable = (builtins.getFlake ${inputs.nixpkgs-unstable}).legacyPackages.x86_64-linux; in
    ${processed}
  ''; # = ./nixpkgs-overlays.nix;
}
