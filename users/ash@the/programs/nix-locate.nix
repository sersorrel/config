{ pkgs, ... }:

{
  home.packages = with pkgs; [ nix-index ];
}
