{ pkgs, ... }:

{
  home.packages = with pkgs; [ qpwgraph ];
  xdg.configFile."autostart/qpwgraph.desktop".text = ''
    [Desktop Entry]
    Name=qpwgraph
    Icon=org.rncbc.qpwgraph
    Exec=qpwgraph -m
    Terminal=false
    Type=Application
    X-GNOME-Autostart-enabled=true
  '';
}
