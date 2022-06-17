{ pkgs, secrets, ... }:

let
  sound = secrets.sounds.slack-ping;
  dunst-notify = pkgs.writeShellScriptBin "dunst-notify" ''
    appname=$1
    summary=$2
    body=$3
    icon=$4
    urgency=$5 # LOW, NORMAL, or CRITICAL
    case "$appname" in
      Slack)
        test -e ${sound} && ${pkgs.pulseaudio}/bin/paplay --volume 45000 ${sound}
        ;;
    esac
  '';
in
{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };
    settings = {
      global = {
        monitor = 0;
        follow = "none";
        width = 300;
        offset = "30x30";
        notification_limit = 5;
        padding = 16;
        horizontal_padding = 16;
        frame_color = "#aaaaaa";
        separator_color = "frame";
        frame_width = 0;
        idle_threshold = 600;
        font = "Source Sans Variable";
        markup = "full";
        format = "%a: <b>%s</b>\\n%b";
        show_age_threshold = 60;
        word_wrap = true;
        icon_position = "left";
        max_icon_size = 24;
        corner_radius = 4;
        dmenu = "/run/current-system/sw/bin/rofi -dmenu -p ''";
        browser = "/run/current-system/sw/bin/google-chrome-stable";
        mouse_left_click = "do_action";
        mouse_middle_click = "close_current";
        mouse_right_click = "close_current";
      };
      urgency_low = {
        background = "#ffffff";
        foreground = "#000000";
        highlight = "#ec008c";
        timeout = 7;
      };
      urgency_normal = {
        background = "#ffffff";
        foreground = "#000000";
        highlight = "#ec008c";
        timeout = 7;
      };
      urgency_critical = {
        background = "#ffffff";
        foreground = "#000000";
        highlight = "#ec008c";
        timeout = 0;
      };
      rule_slack = {
        appname = "Slack";
        script = "${dunst-notify}/bin/dunst-notify";
      };
    };
  };
}
