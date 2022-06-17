{ pkgs, ... }:

{
  home.packages = with pkgs; [ file2img ];
}
