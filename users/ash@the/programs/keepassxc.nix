{ pkgs, ... }:

{
  home.packages = with pkgs; [ keepassxc ];
  programs.i3.extraConfig = [ ''assign [class="^KeePassXC$" title="^(?!Auto-Type - KeePassXC$)"] workspace number 4'' ];
}
