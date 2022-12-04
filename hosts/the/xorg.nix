{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ xorg.xhost ];
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };
    desktopManager = {
      xfce.enable = false;
      wallpaper.mode = "fill";
      runXdgAutostartIfNone = true;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3lock-color
      ];
    };
    updateDbusEnvironment = true;
  };

  # TODO: in picom v10, it may attempt to autostart: https://github.com/yshui/picom/issues/791
  # TODO: in picom v10, the `egl` backend was added, which may solve any problems with `glx`: https://github.com/yshui/picom/pull/878
  services.picom = {
    enable = true;
    backend = "xrender"; # since v10, glx (and egl) stutter badly when moving/resizing windows on top of Chrome
    vSync = true;
    shadow = true;
    shadowExclude = [
      "class_g = 'i3-frame'"
      "class_g = 'i3bar'"
      "class_g = 'flameshot'"
      "_NET_WM_STATE@[*]:a *?= '_NET_WM_STATE_HIDDEN'" # windows in unselected tabs
    ];
    settings.xinerama-shadow-crop = true;
    # Fix flickering after DPMS off
    # https://github.com/yshui/picom/issues/268
    settings.use-damage = false;
    # Avoid showing background on workspace switch
    # https://github.com/yshui/picom/issues/16#issuecomment-792739119
    fade = true;
    fadeDelta = 30;
    fadeSteps = [ 1.0 1.0 ];
  };
}
