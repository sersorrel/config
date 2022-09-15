{ config, inputs, pkgs, ... }:

{
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    secrets.to = { type = "path"; path = "${config.home.homeDirectory}/Secrets"; };
  };

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  nixpkgs.overlays = import ./nixpkgs-overlays.nix { unstable = import inputs.nixpkgs-unstable { system = "x86_64-linux"; }; here = ./.; };
  xdg.configFile."nixpkgs/overlays.nix".text = let
    inherit (pkgs.lib.strings) escapeNixString;
    raw = builtins.readFile ./nixpkgs-overlays.nix;
    prefix = "{ unstable, here }:\n";
    processed = assert pkgs.lib.hasPrefix prefix raw; pkgs.lib.removePrefix prefix raw;
  in ''
    let unstable = (builtins.getFlake ${escapeNixString (toString inputs.nixpkgs-unstable)}).legacyPackages.x86_64-linux; here = /. + ${escapeNixString (toString ./.)}; in
    ${processed}
  ''; # = ./nixpkgs-overlays.nix;
}
