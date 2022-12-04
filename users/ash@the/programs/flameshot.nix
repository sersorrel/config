{ inputs, pkgs, ... }:

{
  services.flameshot.enable = true;
  programs.i3.extraConfig = [ ''for_window [class="^flameshot$"] floating enable, border none'' ];
}
