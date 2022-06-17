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
    ];
    # TODO: mute on step forwards: https://github.com/mpv-player/mpv/issues/6104
  };
}
