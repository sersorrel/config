{ config, lib, pkgs, ... }:

# https://github.com/IvarWithoutBones/dotfiles/blob/df24d3c2410b75a6388015ddf667677118aeca99/home-manager/modules/darwin/applications.nix

let
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = "/Applications";
  };
in
{
  # Home-manager does not link installed applications to the user environment. This means apps will not show up
  # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
  # Upstream issue: https://github.com/nix-community/home-manager/issues/1341
  home.activation.addApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "setting up ~/Applications/Home Manager Apps..." >&2
    nix_apps="$HOME/Applications/Home Manager Apps"

    $DRY_RUN_CMD mkdir -p "$nix_apps"

    $DRY_RUN_CMD chmod a+w "$nix_apps" # so that the below line works
    $DRY_RUN_CMD find "$nix_apps" -maxdepth 1 -exec chmod a+w '{}' + # so that rsync can delete their immediate contents if necessary
    $DRY_RUN_CMD ${pkgs.rsync}/bin/rsync -aL --delete --no-owner --no-group "$(realpath ${apps}/Applications/)"/ "$nix_apps"
    $DRY_RUN_CMD find "$nix_apps" -maxdepth 1 -exec chmod a-w '{}' +
    $DRY_RUN_CMD chmod a-w "$nix_apps"
  '';
}
