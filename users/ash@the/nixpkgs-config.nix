{ pkgs, ... }:

{
  allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "clion"
    "discord"
    "ffmpeg-full"
    "insync"
    "obsidian"
    "rider"
    "slack"
    "steam"
    "steam-original"
    "sublime-merge"
    "talon"
    "talon-beta"
    "todoist-electron"
    "webstorm"
    "zoom"
  ];
}
