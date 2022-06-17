{ secrets, ... }:

{
  programs.ssh = secrets.ssh.config;
}
