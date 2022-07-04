{ pkgs, ... }:

{
  allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "clion"
    "discord"
    "insync"
    "obsidian"
    "slack"
    "steam"
    "steam-original"
    "sublime-merge"
    "talon"
    "talon-beta"
    "todoist-electron"
    "zoom"
  ];
}
