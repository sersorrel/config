{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wineWowPackages.unstableFull
    winetricks
  ];
}
