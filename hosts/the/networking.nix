{ lib, pkgs, secrets, ... }:

{
  networking.networkmanager.enable = true;
  networking.dhcpcd.enable = false; # unsure whether this is actually necessary...

  environment.systemPackages = with pkgs; [ mullvad-vpn ];
  services.mullvad-vpn.enable = true;

  networking.extraHosts = "127.0.0.1 ash";
  services.nginx.enable = true;
  services.nginx.recommendedGzipSettings = true;
  services.nginx.recommendedOptimisation = true;
  services.nginx.recommendedProxySettings = true;
  services.nginx.recommendedTlsSettings = true;
  services.nginx.appendHttpConfig = ''
    # Workaround for the fact that you can't escape dollars in nginx strings
    # https://serverfault.com/a/854600/409674
    geo $dollar {
      default "$";
    }
  '';
  services.nginx.virtualHosts = let
    redirects = secrets.local-redirects;
    escapeNginx = builtins.replaceStrings ["$"] ["\${dollar}"]; # TODO: curly braces, quotes
  in {
    ash = {
      locations = lib.attrsets.mapAttrs' (name: value: { name = "/${name}"; value = { return = "307 ${value}"; }; }) redirects // {
        "/".return = ''200 "<!DOCTYPE html><h1>''${dollar} ash</h1><ul>${escapeNginx (toString (lib.attrsets.mapAttrsToList (name: value: ''<li><a href='${lib.strings.escapeXML value}'>${lib.strings.escapeXML name}</a>'') redirects))}</ul>"'';
        "/".extraConfig = "default_type text/html;";
      };
    };
  };
}
