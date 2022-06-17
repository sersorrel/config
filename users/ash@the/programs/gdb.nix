{ pkgs, ... }:

{
  home.packages = with pkgs; [ gdb ];
  xdg.configFile."gdb/gdbearlyinit".text = ''
    set startup-quietly on
  '';
}
