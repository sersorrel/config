{ inputs, pkgs, ... }:

{
  services.flameshot.enable = false; # TODO: reenable once https://github.com/NixOS/nixpkgs/issues/198505 is widely available
  services.flameshot.package = assert builtins.compareVersions pkgs.flameshot.version "11.0.0" == 0; inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.flameshot;
  programs.i3.extraConfig = [ ''for_window [class="^flameshot$"] floating enable, border none'' ];
}
