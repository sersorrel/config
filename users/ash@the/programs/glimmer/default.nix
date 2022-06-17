{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./glimmer.nix {
      autoreconfHook = pkgs.buildPackages.autoreconfHook269;
      lcms = pkgs.lcms2;
      inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Cocoa;
    })
  ];
}
