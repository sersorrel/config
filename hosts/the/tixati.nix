{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ tixati ];
  networking.firewall = {
    allowedTCPPorts = [ 17810 ];
    allowedUDPPorts = [ 17810 ];
  };
}
