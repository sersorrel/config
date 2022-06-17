{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cinnamon.cinnamon-common # for GSettings reasons
    cinnamon.nemo
  ];
}
