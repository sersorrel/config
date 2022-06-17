{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xfce.xfconf # to save settings
    (xfce.thunar.override {
      thunarPlugins = with pkgs; [
        xfce.thunar-archive-plugin
        xfce.thunar-media-tags-plugin
      ];
    })
  ];
}
