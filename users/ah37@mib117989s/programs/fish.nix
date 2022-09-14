{ pkgs, ... }:

{
  programs.fish = {
    # this doesn't work on darwin by default like it does on linux:
    # https://alecktos.medium.com/nix-home-manager-fish-shell-on-mac-bbd2a598742
    # nix-darwin would solve this, I think (with programs.fish.enable set)
    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "b3dd471bcc885b597c3922e4de836e06415e52dd";
          sha256 = "sha256-3h03WQrBZmTXZLkQh1oVyhv6zlyYsSDS7HTHr+7WjY8=";
        };
      }
    ];
    shellInit = ''
      test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    '';
  };
}
