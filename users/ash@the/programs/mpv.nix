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
      UP = "ignore";
      DOWN = "ignore";
    };
    scripts = [
      pkgs.mpvScripts.mpris
      ((pkgs.writeTextFile {
        name = "mpv-audio-osc";
        executable = true;
        destination = "/share/mpv/scripts/audio-osc.lua";
        text = ''
          function ends_with(value, suffix)
            return suffix == "" or value:sub(-#suffix) == suffix
          end
          mp.register_event("file-loaded", function()
            local hasvid = mp.get_property_osd("video") ~= "no"
            -- that's not accurate if there's embedded album art, so we also test the filename
            local path = mp.get_property("path")
            hasvid = hasvid and not ends_with(path, ".flac")
            hasvid = hasvid and not ends_with(path, ".mp3")
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
