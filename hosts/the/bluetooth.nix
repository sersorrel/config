{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Disable HSP (since we don't have oFono): https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/issues/1149
  hardware.pulseaudio.extraConfig = ''
    .ifexists module-bluetooth-discover.so
    unload-module module-bluetooth-discover
    load-module module-bluetooth-discover headset=ofono
    .endif
  '';
}
