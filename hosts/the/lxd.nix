{ pkgs, ... }:

{
  virtualisation.lxd.enable = true;
  virtualisation.lxc.lxcfs.enable = true;
  # TODO: maybe consider virtualisation.lxd.recommendedSysctlSettings: https://linuxcontainers.org/lxd/docs/master/production-setup/
  systemd.services.lxd.path = [ pkgs.util-linux ]; # TODO: remove once https://github.com/NixOS/nixpkgs/pull/204297 is merged
}
