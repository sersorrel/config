{
  home.file.".xprofile".text = ''
    xset r rate 225 30
    xset -dpms
    xset s off
    brightnessctl set 100%
    autorandr -c
  '';
  home.file.".XCompose".source = ./XCompose;
}
