# TODO: include greasemonkey scripts etc. here

let
  # https://material.io/design/color/the-color-system.html (under "2014 Material Design color palettes")
  blue-100 = "#BBDEFB";
  blue-200 = "#90CAF9";
  bluegrey-50 = "#ECEFF1";
  bluegrey-100 = "#CFD8DC";
  green-100 = "#C8E6C9";
  indigo-100 = "#C5CAE9";
  purple-100 = "#E1BEE7";
  white = "#FFFFFF";
  # https://material.io/design/color/text-legibility.html#text-backgrounds
  text-regular = "rgba(0, 0, 0, 0.87)";
  text-deemphasis = "rgba(0, 0, 0, 0.6)";
  text-disabled = "rgba(0, 0, 0, 0.38)";
in
{
  xdg.dataFile."qutebrowser/userscripts/opent.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      echo "open $@" >> "$QUTE_FIFO"
      giveup=$(( $(date +%s%3N) + 1000 ))
      while read -r event && [ "$(date +%s%3N)" -lt "$giveup" ]; do
        if [ "$(jq -r '.change' <<< "$event")" != "new" ]; then
          continue
        fi
        if [ "$(jq -r '.container.window_properties.class' <<< "$event")" != "qutebrowser" ]; then
          continue
        fi
        i3-msg "[con_id=$(jq '.container.id' <<< "$event")] focus"
        break
      done < <(i3-msg -t subscribe -m '["window"]')
    '';
  };
  programs.qutebrowser = {
    enable = true;
    aliases = {
      "opent" = "spawn --userscript opent.sh";
    };
    keyBindings.normal = {
      J = "spawn i3-msg focus left";
      K = "spawn i3-msg focus right";
      "<Ctrl-Shift-Tab>" = "spawn i3-msg focus left";
      "<Ctrl-Tab>" = "spawn i3-msg focus right";
      gh = "home";
      yf = "hint links yank";
      yt = "tab-clone";
      "<Backspace>" = "back";
      "<Shift-Backspace>" = "forward";
      "<Ctrl-Shift-t>" = "undo --window";
      "<Ctrl-p>" = "print";
      "<F12>" = "devtools";
      # `open` usages that should focus the new window
      "<Ctrl-n>" = "opent -w";
      "<Ctrl-Shift-n>" = "opent -p";
      "O" = "set-cmd-text -s :opent -t";
      "pp" = "open -- {clipboard}";
      "PP" = "opent -t -- {clipboard}";
      "pP" = "open -- {primary}";
      "Pp" = "opent -t -- {primary}";
    };
    settings = {
      auto_save.session = true;
      colors = {
        completion.even.bg = bluegrey-100;
        completion.odd.bg = bluegrey-100;
        completion.fg = text-regular;
        completion.item.selected.bg = blue-100;
        completion.item.selected.border.bottom = blue-200;
        completion.item.selected.border.top = blue-200;
        completion.item.selected.fg = text-regular;
        completion.item.selected.match.fg = text-regular;
        completion.match.fg = text-regular;
        statusbar.caret.bg = indigo-100;
        statusbar.caret.fg = text-regular;
        statusbar.caret.selection.bg = purple-100;
        statusbar.caret.selection.fg = text-regular;
        statusbar.command.bg = bluegrey-50;
        statusbar.command.fg = text-regular;
        statusbar.command.private.bg = bluegrey-100;
        statusbar.command.private.fg = text-regular;
        statusbar.insert.bg = green-100;
        statusbar.insert.fg = text-regular;
        statusbar.normal.bg = bluegrey-50;
        statusbar.normal.fg = text-regular;
        statusbar.passthrough.bg = blue-100;
        statusbar.passthrough.fg = text-regular;
        statusbar.private.bg = bluegrey-100;
        statusbar.private.fg = text-regular;
        statusbar.url.fg = text-regular;
        statusbar.url.hover.fg = text-deemphasis;
        statusbar.url.success.http.fg = text-regular;
        statusbar.url.success.https.fg = text-regular;
        tabs.bar.bg = bluegrey-50;
        tabs.selected.odd.bg = bluegrey-50;
        tabs.selected.odd.fg = text-regular;
        hints.bg = "qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 rgb(255, 247, 133), stop:1 rgb(255, 197, 66))";
        hints.match.fg = "#D4AC3A";
      };
      completion.height = 152;
      completion.quick = false;
      completion.use_best_match = true;
      content.autoplay = false;
      content.headers.accept_language = "en-GB,en-US;q=0.9,en;q=0.8";
      content.pdfjs = true;
      fonts.default_family = "Jost* Book";
      fonts.default_size = "12pt";
      fonts.hints = "bold 11pt Helvetica";
      hints.border = "1px solid #C38A22";
      hints.chars = "asdfghjklwecmp";
      hints.uppercase = true;
      # input.insert_mode.auto_load = true;
      new_instance_open_target = "window"; # https://github.com/qutebrowser/qutebrowser/issues/3593
      scrolling.bar = "always";
      scrolling.smooth = true;
      statusbar.position = "top";
      statusbar.widgets = [ "progress" "keypress" "url" "history" ];
      tabs.indicator.width = 0;
      tabs.tabs_are_windows = true;
      tabs.show = "never";
      tabs.title.alignment = "center";
      tabs.title.format = "{audio}{current_title} [{current_url}]";
      window.title_format = "{perc}{current_title} [{current_url}]{title_sep}qutebrowser";
    };
    extraConfig = ''
      import glob
      c.content.user_stylesheets = glob.glob(str(config.datadir / "usercss" / "*.user.css"))
      try:
        c.hints.selectors["all"].remove("img")
      except ValueError:
        pass
      # https://github.com/qutebrowser/qutebrowser/pull/6758 is not yet in a release
      try:
        c.hints.selectors["all"].remove("[tabindex]")
      except ValueError:
        pass
      c.hints.selectors["all"].append('[tabindex]:not([tabindex="-1"])')
      # https://github.com/qutebrowser/qutebrowser/pull/6757 is not yet in a release
      for role in ["tab", "checkbox", "menuitem", "menuitemcheckbox", "menuitemradio"]:
        c.hints.selectors["all"].append(f'[role="{role}"]')
      # https://github.com/qutebrowser/qutebrowser/issues/4271
      import string
      for letter in list(string.ascii_lowercase):
        config.bind("<Ctrl-]>" + letter, "fake-key " + letter)
      # https://discourse.nixos.org/t/qutebrowser-home-manager-config-issue/16577
      c.statusbar.padding = {"bottom": 2, "left": 2, "right": 2, "top": 2}
      c.tabs.padding = {"bottom": 1, "left": 2, "right": 2, "top": 1}
    '';
  };
}
