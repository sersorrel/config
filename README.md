# config

## setup

```console
$ nix --extra-experimental-features flakes registry add secrets ~/Secrets
$ sudo nixos-rebuild --flake . switch
$ home-manager --flake . switch
```
