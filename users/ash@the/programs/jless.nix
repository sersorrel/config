{ pkgs, ... }:

{
  home.packages = with pkgs; [ jless ];
}
