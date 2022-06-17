{ pkgs, secrets, ... }:

{
  gtk.enable = true;
  gtk.iconTheme = {
    name = "Paper";
    package = pkgs.paper-icon-theme;
  };
  # No proper way to set the cursor theme (yet).
  # https://github.com/NixOS/nixpkgs/issues/22652
  # Likewise, no way to set the sound theme.
  gtk.gtk2.extraConfig = ''
    gtk-cursor-theme-name = "Paper"
    gtk-sound-theme-name = "honk"
  '';
  gtk.gtk3.extraConfig = {
    gtk-cursor-theme-name = "Paper";
    gtk-sound-theme-name = "honk";
  };
  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Inherits=Paper
  '';
  home.sessionVariables.XCURSOR_THEME = "Paper";
  xdg.dataFile."sounds/honk/index.theme".text = ''
    [Sound Theme]
    Name=honk
    Directories=stereo

    [stereo]
    OutputProfile=stereo
  '';
  xdg.dataFile."sounds/honk/stereo/bell.wav".source = secrets.sounds.bell;
}
