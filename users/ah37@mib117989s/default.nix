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

    programs.home-manager.enable = true;
  };
}
