{ pkgs, ... }:

{
  home.packages = with pkgs; [ zulip ];
}
