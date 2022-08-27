{
  services.jupyter.enable = true;
  services.jupyter.password = "''"; # use auth tokens rather than passwords
  users.users.jupyter.group = "jupyter";
}
