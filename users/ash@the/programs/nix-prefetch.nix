{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nix-prefetch-github
    nix-prefetch-scripts
  ];
}
