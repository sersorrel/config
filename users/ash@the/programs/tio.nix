{ pkgs, ... }:

{
  home.packages = with pkgs; [ tio ];
}
