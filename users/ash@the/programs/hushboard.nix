{ pkgs, ... }:

{
  home.packages = with pkgs; [ hushboard ];
}
