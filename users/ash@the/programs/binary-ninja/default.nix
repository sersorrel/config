{ pkgs, secrets, ... }:

{
  home.packages = with pkgs; [ (callPackage ./binary-ninja.nix {}) ];
}
