{
  imports = [ ./jupyter.nix ];
  services.jupyter.enable = true;
  services.jupyter.password = "''"; # use auth tokens rather than passwords
}
