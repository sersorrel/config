{ pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    pulse.enable = true;
  };
  environment = {
    systemPackages = with pkgs; [ ladspaPlugins pavucontrol pulseaudio ]; # we still need pactl from pulseaudio
    variables.LADSPA_PATH = "/run/current-system/sw/lib/ladspa";
  };
}
