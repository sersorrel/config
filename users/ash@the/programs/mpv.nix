{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    config = {
      keep-open = true;
      osd-on-seek = false;
      osd-msg3 = "\${osd-sym-cc} \${time-pos} / \${duration} (\${percent-pos}%), \${time-remaining} left";
    };
    bindings = {
      HOME = "seek 0 absolute+exact";
      END = "seek 100 absolute-percent+exact";
    };
    scripts = [
      pkgs.mpvScripts.mpris
      ((pkgs.writeTextFile {
        name = "mpv-audio-osc";
        executable = true;
        destination = "/share/mpv/scripts/audio-osc.lua";
        text = ''
          mp.register_event("file-loaded", function()
            local hasvid = mp.get_property_osd("video") ~= "no"
            mp.commandv("script-message", "osc-visibility", (hasvid and "auto" or "always"), "no-osd")
            -- remove the next line if you don't want to affect the osd-bar config
            mp.commandv("set", "options/osd-bar", (hasvid and "yes" or "no"))
          end)
        '';
      }).overrideAttrs (old: {
        passthru.scriptName = "audio-osc.lua";
      }))
    ];
    # TODO: mute on step forwards: https://github.com/mpv-player/mpv/issues/6104
  };
}
