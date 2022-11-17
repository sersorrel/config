{ pkgs, ... }:

{
  home.packages = with pkgs; [ gdb ];
  xdg.configFile."gdb/gdbearlyinit".text = ''
    set startup-quietly on
  '';
  xdg.configFile."gdb/gdbinit".text = ''
    set print thread-events off
    set pagination off
    set non-stop on
    set disassembly-flavor intel
  '';
}
