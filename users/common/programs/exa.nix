{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [ exa ];
  home.sessionVariables.EXA_COLORS = lib.concatStringsSep ":" [
    "core=1;31"
  ];
}
