{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ ripgrep ];
  home.sessionVariables.RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgrep/config";
  xdg.configFile."ripgrep/config".text = ''
    --smart-case
    --max-columns
    1000
    --max-columns-preview
    --multiline-dotall
    --ignore-file
    ${config.xdg.configHome}/ripgrep/ignore
    --type-add
    cfg:*.cfg
  '';
  xdg.configFile."ripgrep/ignore".text = ''
    Cargo.lock
    Gemfile.lock
    flake.lock
    package-lock.json
    poetry.lock
  '';
}
