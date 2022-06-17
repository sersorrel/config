{
  services.xserver = {
    # defaults used for keyboards hotplugged after login
    # equivalent to `xset r rate 225 30`
    autoRepeatDelay = 225;
    autoRepeatInterval = 1000 / 30;

    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      # turn off left+right => middle
      mouse.middleEmulation = false;
    };

    # https://twitter.com/mycoliza/status/1161307160254410753
    layout = "gb-qw0rty";
    xkbOptions = "caps:super,altwin:swap_lalt_lwin,lv3:ralt_switch_multikey,grab:debug"; # ctrl-alt-F11 for grabs debug info
    extraLayouts.gb-qw0rty = {
      description = "English (UK) (qw0rty)";
      languages = [ "eng" ];
      symbolsFile = ./qw0rty/symbols/gb-qw0rty;
    };
  };
  console.useXkbConfig = true;
}
