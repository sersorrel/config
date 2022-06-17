{
  boot.cleanTmpDir = true;

  environment.etc."machine-id".source = "/persist/etc/machine-id";

  fileSystems."/".options = [ "defaults" "size=8G" "mode=755" ];
  fileSystems."/home".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;

  services.fstrim.enable = true;

  services.udev.extraRules = ''
    # Mount Az in /media rather than in /run/media/$USER.
    ENV{ID_FS_UUID}=="6c2e615b-73e4-40c5-99ae-253fc2c506da", ENV{UDISKS_FILESYSTEM_SHARED}="1"
  '';

  systemd.tmpfiles.rules = [
    # Create and clean /media (like /run)
    "D /media 0755 root root 0 -"
  ];
}
