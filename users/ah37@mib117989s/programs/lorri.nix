{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ lorri ];
  launchd.agents.lorri = {
    enable = true;
    config = {
      WorkingDirectory = "${config.home.homeDirectory}";
      EnvironmentVariables = {
        PATH = "${pkgs.nix}/bin";
      };
      StandardOutPath = "/tmp/lorri-${config.home.username}-stdout.log";
      StandardErrorPath = "/tmp/lorri-${config.home.username}-stderr.log";
      ProgramArguments = [ "${pkgs.lorri}/bin/lorri" "daemon" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
