{ pkgs, secrets, ... }:

{
  home.packages = with pkgs; [ (callPackage ./rcu.nix { srcs = secrets.src.rcu; }) ];
}
