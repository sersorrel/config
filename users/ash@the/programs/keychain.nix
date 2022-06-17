{
  programs.keychain = {
    enable = true;
    agents = [ "ssh" ];
    keys = [ "id_ed25519" ];
  };
  # Work around https://github.com/nix-community/home-manager/issues/2256
  # Can probably be removed once 22.11 is released.
  programs.keychain.enableBashIntegration = false;
}
