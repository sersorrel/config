{ lib, ... }:

{
  xdg.dataFile."applications/fish.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=fish
    Exec=fish
    Terminal=true
    NoDisplay=true
  '';
  programs.fish = {
    enable = true;
    functions = {
      apt-provides = ''
        apt-cache show (apt-cache search $argv[1] | awk '{ print $1 }') | sed -n '/^Package: \(.*\)$/ {s//\1/;h}; /^Provides:.*'"$argv[1]"'/ {x;p}'
      '';
      copy = {
        wraps = "xclip";
        body = "xclip -sel clip $argv";
      };
      diff = {
        wraps = "diff";
        body = "command diff -u $argv"; # TODO: maybe use colordiff or kitty's diff here?
      };
    } // lib.attrsets.genAttrs [ "ffmpeg" "ffplay" "ffprobe" ] (binary: {
      wraps = binary;
      body = "command ${binary} -hide_banner $argv";
    }) // {
      bang_binding = ''
        switch (commandline -t)
          case "!"
            commandline -t $history[1]
            commandline -f repaint
          case "*"
            commandline -i !
        end
      '';
      fish_user_key_bindings = ''
        # https://github.com/fish-shell/fish-shell/wiki/Bash-Style-Command-Substitution-and-Chaining-
        bind ! bang_binding
        # https://github.com/fish-shell/fish-shell/issues/3011
        bind \cf accept-autosuggestion
        # we have fzf for more sophisticated searching
        bind \e\[A history-prefix-search-backward
        bind \e\[B history-prefix-search-forward
        # repaint the prompt on return (both "when a command is executed" as well as "any other time return is pressed at a prompt")
        # see https://github.com/fish-shell/fish-shell/pull/8142 for inspiration, though we don't actually need that feature
        # this means that the time shown in the prompt is the time the command was run, not the time the prompt was first printed
        bind \r repaint execute
      '';
      https = {
        wraps = "http";
        body = "http --default-scheme https $argv";
      };
      icat = "kitty +kitten icat --align left --place (math $COLUMNS - 2)x(math $LINES - 2)@0x(math $LINES - 1) $argv";
      kd = {
        wraps = "fd";
        body = "kitty +kitten hyperlinked_fd $argv";
      };
      kg = {
        wraps = "rg";
        body = "kitty +kitten hyperlinked_rg $argv";
      };
      la = ''
        if test -n $argv[1]
          if test -d $argv[1]
            ls -aa $argv[2..] -- $argv[1]
          else if test -f $argv[1]
            less -N $argv[2..] -- $argv[1]
          else
            ls -aa $argv
          end
        else
          ls -aa
        end
      '';
      less = {
        wraps = "less";
        body = "command less -N $argv";
      };
      l = ''
        if test -n $argv[1]
          if test -d $argv[1]
            ls $argv[2..] -- $argv[1]
          else if test -f $argv[1]
            less -N $argv[2..] -- $argv[1]
          else
            ls $argv
          end
        else
          ls
        end
      '';
      ll = {
        wraps = "exa";
        body = "ls -al $argv";
      };
      ls = {
        wraps = "exa";
        body = "exa --group -F $argv";
      };
      mkcd = {
        wraps = "mkdir";
        body = "mkdir -p -- $argv[1] && cd -- $argv[1]";
      };
      now = "date +%s";
      oops = "history delete --exact --case-sensitive -- $history[1]";
      rm = {
        wraps = "rm";
        body = "command rm --interactive=never $argv";
      };
      rn = ''
        set filename (date +"%Y-%m-%d-%H%M%S")
        if test (count $argv) -gt 0
          set filename "$filename"-(string join -- - $argv)
        end
        mkdir -p ~/.rn
        mkdir ~/.rn/$filename
        cd ~/.rn/$filename
      '';
      v = {
        wraps = "nvim";
        body = "nvim $argv";
      };
      venv = ''
        set dir $argv[1]
        test -z "$dir"; and set dir "venv"
        source "./$dir/bin/activate.fish"
      '';
      whenis = "date -d @$argv[1]";
      yeet = ''
        echo "really yeet "(pwd)"? (ctrl-c if not)"
        if read
          rm -r (pwd)
          cd ..
        end
      '';
    };
    interactiveShellInit = ''
      # Most modern terminals automatically rewrap text, don't try and preempt them.
      set -g fish_handle_reflow 0
      # Set up our version of lessfile.
      janus | source
    '';
    shellInit = ''
      function fish_greeting
      end
      if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION enabled
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
      end
    '';
  };
}
