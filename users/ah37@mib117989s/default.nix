{
  system = "aarch64-darwin";
  username = "ah37";
  homeDirectory = "/Users/ah37";
  stateVersion = "22.05";
  configuration = { lib, pkgs, ... }: {
    imports = [
      ../common
      ./applications.nix
      ./programs
    ];

    # quick hack for the time being
    programs.git.extraConfig.core.editor = lib.mkForce "vim";

    programs.home-manager.enable = true;
  };
}
