{ pkgs, ... }:

let
  firefox-customised = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
    safeBrowsingSupport = true;
    drmSupport = true;
  }) {
    extraPrefs = ''
      // TODO
      // defaultPref(name, val) or lockPref(name, val) is probably the thing to use here
    '';
  };
in
{
  home.packages = with pkgs; [ firefox ]; # TODO: firefox-customised
}
