{
  programs.readline = {
    enable = true;
    # TODO: fix
    # bindings = {
    #   ''\e[A'' = "history-search-backward"; # up arrow
    #   ''\e[B'' = "history-search-forward"; # down arrow
    #   ''\t'' = "menu-complete";
    #   ''\e[Z'' = "menu-complete-backward";
    #   ''\C-w'' = "backward-kill-word";
    # };
    variables = {
      colored-stats = true; # show file type by trailing character
      visible-stats = true; # show file type by colour
      colored-completion-prefix = true; # colour any common completion prefix differently
      completion-prefix-display-length = 10; # cap the length of the displayed common prefix
      show-all-if-ambiguous = true; # show all completions immediately if ambiguous
      menu-complete-display-prefix = true; # complete as far as possible first, though
      bind-tty-special-chars = false; # so we can use a more useful definition of "word" for ^W
      completion-ignore-case = true;
      enable-bracketed-paste = true;
      keyseq-timeout = 200; # reduce the delay between pressing escape and exiting i-search
    };
  };
}
