{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    lyx
    texlive.combined.scheme-full
  ];
  home.file.".latexmkrc" = lib.mkIf (builtins.elem pkgs.evince config.home.packages) {
    text = ''
      $pdf_previewer = 'start evince %O %S'
    '';
  };
}
