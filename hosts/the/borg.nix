{ pkgs, secrets, ... }:

{
  environment.systemPackages = with pkgs; [ borgbackup ];
  services.borgbackup.jobs = {
    persist = {
      paths = [ "/persist" ];
      repo = "/media/Az/shared/borg/the";
      doInit = false;
      removableDevice = true;
      # This doesn't work, since the job can't run unless the drive is mounted (see systemd ReadWritePaths).
      # If the path was made optional, it wouldn't have write permissions to it once it was mounted.
      # preHook = ''
      #   ${pkgs.glib}/bin/gio mount -d 6c2e615b-73e4-40c5-99ae-253fc2c506da
      # '';
      encryption = {
        mode = "repokey";
        passCommand = secrets.backups."the/persist -> az".passCommand;
      };
      compression = "zstd";
      prune = {
        keep = {
          within = "6m";
        };
      };
      startAt = "13:00:00";
    };
  };
}
