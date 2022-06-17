{ pkgs, ... }:

{
  home.sessionPath = [ (toString ~/.local/bin) ];
  home.file.".local/bin" = {
    source = ./.;
    recursive = true;
  };
  # We just make sure some packages are available globally, because using nix-script for latency-sensitive scripts sucks.
  home.packages = with pkgs; [
    jq
    moreutils
  ];
}
