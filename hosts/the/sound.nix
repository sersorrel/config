{ pkgs, ... }:

{
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  environment = {
    systemPackages = with pkgs; [ ladspaPlugins pavucontrol ];
    variables.LADSPA_PATH = "/run/current-system/sw/lib/ladspa";
  };
}
