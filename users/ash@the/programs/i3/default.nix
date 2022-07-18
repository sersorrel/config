{ config, lib, pkgs, ... }:

let
  fa-bluetooth-b = builtins.fromJSON ''"\uF294"'';
  fa-headphones = builtins.fromJSON ''"\uF025"'';
  fa-microphone = builtins.fromJSON ''"\uF130"'';
  fa-microphone-slash = builtins.fromJSON ''"\uF131"'';
  fa-bell-slash = builtins.fromJSON ''"\uF1F6"'';
  fa-sync = builtins.fromJSON ''"\uF021"'';
  fa-times = builtins.fromJSON ''"\uF00D"'';
  fa-tv = builtins.fromJSON ''"\uF26C"'';
  fa-university = builtins.fromJSON ''"\uF19C"'';
in
{
  options = {
    programs.i3.extraConfig = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = ''
        Additional lines of configuration to append to the i3 config file.
      '';
    };
  };

  config = {
    home.packages = with pkgs; [
      lm_sensors # for i3status-rust
      uoyweek # for i3status-rust
      xdotool # for i3 itself (flameshot, https://github.com/flameshot-org/flameshot/issues/784)
    ];
    gtk.gtk2.extraConfig = ''
      gtk-decoration-layout = "icon:menu"
    '';
    gtk.gtk3.extraConfig = {
      gtk-decoration-layout = "icon:menu";
    };
    xdg.configFile."i3/config".text = (builtins.readFile ./config) + "\n" + lib.strings.concatStringsSep "\n" config.programs.i3.extraConfig;
    xdg.configFile."rofi/config.rasi".text = ''
      @theme "gruvbox-dark"
      configuration {
        show-icons: true;
        icon-theme: "Paper";
        modi: "window,run,ssh,drun";
        monitor: "-1";
        drun-match-fields: "name";
        tokenize: true;
        sort: true;
        sorting-method: "fzf";
        matching: "fuzzy";
      }
      // Hide the colon at the start of the textbox.
      textbox-prompt-sep {
        enabled: false;
      }
      // Make the application icons a reasonable size.
      element-icon {
        size: 1.2em;
      }
    '';
    programs.i3status-rust = {
      enable = true;
      bars.default = {
        settings = {
          theme = {
            name = "gruvbox-light";
            overrides = {
              idle_bg = "#FFFFFF00";
              info_bg = "#FFFFFF00";
              good_bg = "#FFFFFF00";
              idle_fg = "#FBF1C7FF";
              info_fg = "#FBF1C7FF";
              good_fg = "#FBF1C7FF";
              alternating_tint_bg = "#00000000";
              warning_fg = "#FBF1C7FF";
              separator = "";
            };
          };
          icons = {
            name = "awesome";
            overrides = {
              time = builtins.fromJSON ''"\uF133"'';
              net_wired = builtins.fromJSON ''"\uF0AC"'';
              net_wireless = builtins.fromJSON ''"\uF1EB"'';
              phone_disconnected = builtins.fromJSON ''"\uF10B"'';
            };
          };
        };
        blocks = [
          {
            block = "custom";
            command = "systemctl --quiet is-active borgbackup-job-persist.service && printf '${fa-sync}'";
            hide_when_empty = true;
            shell = "sh";
          }
          {
            block = "custom";
            command = ''if [ "$(dunstctl is-paused)" = "true" ]; then printf '${fa-bell-slash}'; fi'';
            on_click = "dunstctl set-paused false";
            hide_when_empty = true;
            shell = "sh";
          }
          {
            block = "custom";
            command = ''if ${pkgs.pulseaudio}/bin/pactl get-source-mute @DEFAULT_SOURCE@ | grep -qF "Mute: yes"; then printf '${fa-microphone-slash}'; else printf '${fa-microphone}'; fi'';
            on_click = "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            shell = "sh";
          }
          {
            block = "sound";
            format = "${fa-headphones}";
          }
          {
            block = "disk_space";
            format = builtins.fromJSON ''"\uF312"'' + " {available:1; M}";
            path = "/nix";
            warning = 10;
            alert = 5;
          }
          {
            block = "disk_space";
            format = builtins.fromJSON ''"\uF0A0"'' + " {available:1; M}";
            path = "/persist";
            warning = 10;
            alert = 5;
          }
          {
            block = "disk_space";
            format = "/ {available:1; M}";
            path = "/";
            warning = 10;
            alert = 5;
          }
          {
            block = "net";
            device = "wlp3s0";
            format = "{ssid}";
            format_alt = "";
          }
          {
            block = "net";
            device = "enp4s0f1";
            format = "";
          }
          {
            block = "custom";
            command = ''if [ "$(dbus-send --system --dest=org.bluez --print-reply=literal /org/bluez/hci0 org.freedesktop.DBus.Properties.Get string:org.bluez.Adapter1 string:Powered | grep "boolean true")" ]; then printf '${fa-bluetooth-b}'; else printf '${fa-bluetooth-b} ×'; fi'';
            shell = "sh";
          }
          {
            block = "memory";
            clickable = false;
            format_mem = "{mem_used:1;_G*_}/{mem_total:1;_G*_}";
            warning_mem = 90;
          }
          {
            block = "memory";
            display_type = "swap";
            clickable = false;
            format_swap = "{swap_used:1;_G*_}/{swap_total:1;_G*_}";
            warning_swap = 50;
          }
          {
            block = "custom";
            command = ''printf '${fa-tv} '; nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | awk 'BEGIN { FS = ", " } ; { printf "%.1f/%.1f",$1/1024,$2/1024 }';'';
            shell = "sh";
          }
          {
            block = "battery";
            format = "{percentage:1} {time} {power:1}";
            driver = "upower";
          }
          {
            block = "kdeconnect";
            format = "{bat_charge:1}";
            format_disconnected = "${fa-times}";
            bat_warning = 20;
            bat_critical = 10;
          }
          {
            block = "temperature";
            chip = "coretemp-isa-0000";
            collapsed = false;
            format = "{average}";
            idle = 80;
            info = 90;
            warning = 100;
          }
          {
            block = "uptime";
          }
          {
            block = "custom";
            command = ''printf '${fa-university} '; uoyweek'';
            interval = 120;
            shell = "sh";
          }
          {
            block = "time";
            format = "%A %F %-I:%M %P";
            interval = 2;
          }
        ];
      };
    };
  };
}
