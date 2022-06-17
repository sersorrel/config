{ pkgs, ... }:

{
  home.packages = with pkgs; [ zoom-us ];
  programs.i3.extraConfig = [
    ''for_window [class="zoom" title="Breakout Rooms - In Progress"] floating enable''
    ''for_window [class="zoom" title="zoom"] floating enable, resize set width 500 px height 100 px''
    ''for_window [class="zoom" title="Zoom - Licensed Account"] floating disable''
  ];
}
