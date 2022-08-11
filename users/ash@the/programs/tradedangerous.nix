{ config, inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    (inputs.mach-nix.lib.x86_64-linux.buildPythonApplication rec {
      pname = "tradedangerous";
      version = "10.13.7";
      src = python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "sha256-pON4MXc29mZOXnzh4semffKjBr7XhcBe8yz8NqjkSko=";
      };
      requirements = ''
        appJar
        pytest-runner
        requests
      '';
    })
  ];
  home.sessionVariables = {
    TD_DATA = "${config.xdg.cacheHome}/tradedangerous";
    TD_TMP = "${config.xdg.dataHome}/tradedangerous";
  };
}
