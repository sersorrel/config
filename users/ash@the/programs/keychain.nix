{
  programs.keychain = {
    enable = true;
    agents = [ "ssh" ];
    keys = [ "id_ed25519" ];
    extraFlags = [ "--noask" "--quiet" ];
  };
}
