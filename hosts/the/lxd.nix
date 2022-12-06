{ pkgs, ... }:

{
  virtualisation.lxd.enable = true;
  virtualisation.lxc.lxcfs.enable = true;
  # TODO: maybe consider virtualisation.lxd.recommendedSysctlSettings: https://linuxcontainers.org/lxd/docs/master/production-setup/
}
