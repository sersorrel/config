{ pkgs, ... }:

{
  boot.kernelParams = [ "delayacct" ];
  environment.systemPackages = with pkgs; [ iotop ];
}
