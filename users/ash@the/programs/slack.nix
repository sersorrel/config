{ pkgs, ... }:

{
  home.packages = with pkgs; [ slack ];
  programs.i3.extraConfig = [ ''assign [class="^Slack$"] workspace number 3'' ];
  # Avoid filling system logs with console.log spam.
  home.sessionVariables.SLACK_DEBUG_LEVEL = "warn";
}
