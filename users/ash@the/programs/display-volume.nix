{ pkgs, ... }:

{
  home.packages = with pkgs; [ display-volume ];
}
