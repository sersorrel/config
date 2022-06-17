{ pkgs, ... }:

{
  home.packages = with pkgs; [ pngcrush ];
}
