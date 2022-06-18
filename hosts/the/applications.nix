{ pkgs, ... }:

{
  # don't clobber users' shell functions!
  environment.shellAliases = {
    l = null;
    ll = null;
    ls = null;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    google-chrome
    ncdu
    git
    github-cli
    file
    pciutils
    usbutils
    glxinfo
    polkit_gnome
    gnome.adwaita-icon-theme
    gnome.cheese
    gnome.file-roller
    gnome.eog
    gnome.gnome-system-monitor
    gnome.gnome-power-manager
    gnome.gnome-boxes
    networkmanagerapplet
    gparted
    gcc
    man-pages
    man-pages-posix
  ];

  documentation.dev.enable = true;

  programs.adb.enable = true;

  programs.dconf.enable = true;

  programs.fish.enable = true;

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  services.autorandr.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true; # resolve .local names
  };

  services.colord.enable = true;

  services.gnome = {
    tracker.enable = true;
    tracker-miners.enable = true;
  };

  services.gvfs.enable = true;

  services.tumbler.enable = true;

  services.upower.enable = true;
}
