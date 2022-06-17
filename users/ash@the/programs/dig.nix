{ pkgs, ... }:

{
  home.packages = with pkgs; [ dig ];
  home.file.".digrc".text = ''
    +noall +answer +ttlunits +multiline
  '';
}
