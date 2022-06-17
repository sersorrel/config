{ pkgs, ... }:

{
  home.packages = with pkgs; [ kid3 ];
}
