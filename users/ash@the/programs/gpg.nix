{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnupg
    pinentry-gtk2
  ];
  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry
  '';
}
