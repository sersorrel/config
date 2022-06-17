{ config, secrets, ... }:

{
  xdg.configFile."git/message".text = "\n";
  programs.git = {
    enable = true;
    userName = secrets.my.name;
    userEmail = secrets.my.email;
    aliases = {
      cherrypick = "cherry-pick";
      man = "help";
      s = "status";
      unstage = "reset HEAD --";
      update = "fetch --all --prune";
      ff = "merge --ff-only";
      ffs = "ff --no-stat";
      hash = ''!f() { git rev-parse "''${1:-HEAD}" | GREP_COLORS="ms=34;1" grep --color "$(git rev-parse --short=0 "''${1:-HEAD}")"; }; f'';
      ref = "show -s --pretty=reference";
      staged = "diff --cached";
      remotes = "remote -vv";
      branches = "branch -vv --list";
      stashes = "stash list";
      tags = "tag --list";
      worktrees = "worktree list";
      aliases = "!git config -l | grep alias | cut -c 7-";
      ls = "log --pretty=format:'%C(yellow)%h%C(auto)%d %C(reset)%s %C(cyan)%an %C(green)%ar %C(reset)%C(dim)(%G?)%C(nodim)' --decorate";
      graph = "ls --graph";
      g = "graph";
      aa = "graph --exclude=refs/stash --all";
      faa = "aa --format=fuller";
      last = "!git --no-pager log -n 1 HEAD";
      details = "log -n 1 -p --format=fuller";
      changes = ''!git ls "''${1:-@}...''${1:-}@{u}"'';
      descended-from = "branch -a --contains";
      yeet = ''!f() { branch_name="$(git symbolic-ref --short HEAD)" && read -p "Really yeet $branch_name? (ctrl-c if not)" _ && git switch @{-1} && git branch -D "$branch_name"; }; f'';
    };
    attributes = [
      "*.c diff=cpp"
      "*.cpp diff=cpp"
      "*.css diff=css"
      "*.html diff=html"
      "*.md diff=markdown"
      "*.php diff=php"
      "*.py diff=python"
    ];
    ignores = [
      "__pycache__/"
      "*.py[co]"
      "/build/"
      "/dist/"
      "*.egg-info"
      "*.egg"
      "/.eggs/"
      "venv/"
      ".venv/"
      ".mypy_cache/"
      ".idea/"
      "*~"
      ".*.sw?"
      "/tags"
      "/tags.temp"
      "/tags.lock"
      "*.aux"
      "*.fdb_latexmk"
      "*.fls"
      "*.log"
      "*.out"
      "*.o"
      ".nix-script-cache/"
    ];
    extraConfig = {
      core = {
        editor = "nvim";
        whitespace = "blank-at-eol,blank-at-eof,space-before-tab";
        pager = "some";
      };
      color = {
        ui = "auto";
      };
      commit = {
        verbose = true;
        template = "${config.xdg.configHome}/git/message";
      };
      diff = {
        indentHeuristic = true;
        renames = "copies";
        algorithm = "histogram";
        wsErrorHighlight = "all";
        submodule = "log";
        colorMoved = true;
      };
      fetch = {
        prune = true;
      };
      init = {
        defaultBranch = "main";
      };
      interactive = {
        singleKey = true;
      };
      log = {
        date = "iso";
      };
      merge = {
        conflictStyle = "diff3";
        ff = false;
      };
      pull = {
        ff = "only";
      };
      push = {
        default = "current";
        followTags = true;
      };
      rebase = {
        autoSquash = true;
        missingCommitsCheck = "error";
      };
      sendemail = {
        annotate = true;
        confirm = "always";
      };
      stash = {
        showPatch = true;
      };
      submodules = {
        recurse = true;
      };
      tag = {
        sort = "version:refname";
      };
      versionsort = {
        suffix = builtins.concatMap (v: [v ("-" + v)]) [
          "a"
          "alpha"
          "b"
          "beta"
          "pre"
          "rc"
        ];
      };
    };
  };
}
