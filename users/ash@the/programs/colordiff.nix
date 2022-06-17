{ pkgs, ... }:

{
  home.packages = with pkgs; [ colordiff ];
  xdg.configFile."colordiff/colordiffrc".text = ''
    banner=no
  '';
}
