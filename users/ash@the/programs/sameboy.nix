{ pkgs, ... }:

{
  home.packages = with pkgs; [ sameboy ];
  programs.i3.extraConfig = [ ''for_window [class="^.sameboy-wrapped$"] floating enable'' ];
}
