{ inputs, ... }:

{
  home.packages = [ inputs.nix-script.packages.x86_64-linux.nix-script-all ];
}
