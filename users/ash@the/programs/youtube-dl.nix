{ pkgs, ... }:

{
  home.packages = with pkgs; [ python39Packages.youtube-dl ];
}
