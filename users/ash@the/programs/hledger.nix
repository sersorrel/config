{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ hledger ];
  home.sessionVariables.LEDGER_FILE = "${config.home.homeDirectory}/ledger/2022.journal";
}
