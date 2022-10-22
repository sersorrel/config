{ pkgs, ... }:

{
  home.packages = with pkgs; [ anki ];
  programs.i3.extraConfig = [ ''for_window [class="Anki"] floating enable'' ];
}
