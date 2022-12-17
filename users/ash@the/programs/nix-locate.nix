{ config, inputs, pkgs, ... }:

{
  home.packages = with pkgs; [ nix-index ];
  home.file."${toString config.xdg.cacheHome}/nix-index/files".source = inputs.nix-index-database.legacyPackages.${pkgs.system}.database;
}
