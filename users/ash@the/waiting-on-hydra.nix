{ config, pkgs, ... }:

let
  curl = "${pkgs.curl}/bin/curl";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  sed = "${pkgs.gnused}/bin/sed";
  grep = "${pkgs.gnugrep}/bin/grep";
  cp = "${pkgs.coreutils}/bin/cp";
  rm = "${pkgs.coreutils}/bin/rm";
  mktemp = "${pkgs.coreutils}/bin/mktemp";
  inputFile = "${config.home.homeDirectory}/.waiting-on-hydra";
  workingFile = "${inputFile}.tmp";
  script = pkgs.writeShellScript "waiting-on-hydra.sh" ''
    ${cp} -- "${inputFile}" "${workingFile}"
    while IFS= read -r line; do
      echo "Checking PR $line"
      result=$(${curl} -s -A "waiting-on-hydra (ash at sorrel dot sh)" "https://nixpk.gs/pr-tracker.html?pr=$line")
      curl=$?
      if [ $curl -ne 0 ]; then
        echo "curl exited with $curl!"
        if [ $curl -eq 6 ]; then
          echo "probably no internet connection."
        else
          name=$(${mktemp} --tmpdir waiting-on-hydra-XXXXXX)
          printf '%s' "$result" > "$name"
          ${notify-send} -u critical -t 0 "waiting-on-hydra" "curl exited with $curl for PR $line, output is in $name"
        fi
        continue
      fi
      ${grep} -qF 'class="state-pending"' <<< "$result"
      is_pending=$?
      ${grep} -qF 'class="state-accepted"' <<< "$result"
      is_merged=$?
      if [ $is_pending -eq 1 ] && [ $is_merged -eq 0 ]; then
        echo "PR is merged."
        title=$(${grep} -F '<title>' <<< "$result" | ${grep} -o '(".*")')
        ${notify-send} -t 0 "waiting-on-hydra: $line $title" "this PR is merged to all branches"
        ${sed} -i "/$line/d" -- "${inputFile}"
      elif [ $is_pending -eq 1 ] && [ $is_merged -eq 1 ]; then
        echo "PR is in invalid state!"
        name=$(${mktemp} --tmpdir waiting-on-hydra-XXXXXX)
        printf '%s' "$result" > "$name"
        ${notify-send} -u critical -t 0 "waiting-on-hydra" "didn't find either class for PR $line, output is in $name"
      else
        echo "PR is in progress."
      fi
      sleep 5 # try and be at least a bit nice to the public pr-tracker instance
    done < ${workingFile}
    echo "All done."
    ${rm} -- "${workingFile}"
  '';
in
{
  systemd.user.timers.waiting-on-hydra = {
    Unit = {
      Description = "Regularly check for merged nixpkgs PRs";
      PartOf = [ "waiting-on-hydra.service" ];
    };
    Timer = {
      OnStartupSec = 60 * 5; # 5 minutes after login
      OnUnitActiveSec = 60 * 30; # every 30 minutes thereafter
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
  systemd.user.services.waiting-on-hydra = {
    Unit = {
      Description = "Check for merged nixpkgs PRs";
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${script}";
    };
  };
}
