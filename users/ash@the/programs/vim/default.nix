{ lib, pkgs, ... }:

let
  removeAttrs = attrs: lib.attrsets.filterAttrs (attr: _: builtins.all (x: attr != x) attrs);
  vim_config = removeAttrs ["override" "overrideDerivation" "overrideAttrs"] (pkgs.callPackage ./vim.nix {});
  vim_configured = pkgs.vim_configurable.customize vim_config;
in
{
  home.packages = with pkgs; [ vim_configured ];
  xdg.dataFile."applications/vim.desktop".text = ''
    [Desktop Entry]
    Name=Vim
    Icon=vim
    Type=Application
    Exec=${vim_configured}/bin/gvim -f %F
    Terminal=false
    StartupNotify=true
    MimeType=text/*;
  '';
}
