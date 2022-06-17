{ pkgs, ... }:

{
  home.packages = with pkgs; [ eiciel ];
  programs.i3.extraConfig = [ ''for_window [class="^Eiciel$"] floating enable'' ];
}
