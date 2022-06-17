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

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    shadow = true;
    shadowExclude = [
      "class_g = 'i3-frame'"
      "class_g = 'i3bar'"
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
