{ pkgs, ... }:

{
  home.packages = with pkgs; [ gnome.zenity ];
}
