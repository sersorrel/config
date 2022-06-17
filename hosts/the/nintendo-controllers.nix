{ config, lib, pkgs, ... }:

{
  boot.extraModulePackages = assert lib.versionOlder pkgs.linux.version "5.16"; with config.boot.kernelPackages; [ hid-nintendo ];
  services.joycond.enable = true;
}
