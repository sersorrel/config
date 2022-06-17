{ pkgs, ... }:

{
  home.packages = with pkgs; [ bintools ];
}
