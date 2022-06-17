{ pkgs, secrets, ... }:

{
  home.packages = with pkgs; [
    (callPackage ./talon.nix {})
    (callPackage ./talon-beta.nix { srcs = secrets.src.talon-beta; })
  ];
}
