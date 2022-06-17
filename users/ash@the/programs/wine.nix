{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wineWowPackages.unstable
    winetricks
  ];
}
