{ lib, pkgs, ... }:

let
  ftl-config-file = "~/.config/obs-studio/plugin_config/rtmp-services/services.json";
in
{
  home.packages = with pkgs; [ obs-studio ];
  home.activation.obs-hacksoc-ftl = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${pkgs.jq}/bin/jq '.services |= (map(select(.name != "HackSoc Lightspeed")) | . += [{"name": "HackSoc Lightspeed", "common": true, "servers": [{"name": "HackSoc Live", "url": "https://live.hacksoc.org"}], "recommended": {"keyint": 2,"output": "ftl_output", "bframes": 0}}])' ${ftl-config-file} | ${pkgs.moreutils}/bin/sponge ${ftl-config-file}
  '';
}
