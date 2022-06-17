{ lib, pkgs, ... }:

let
  cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
  srcFilters = [
    (path: type: lib.strings.hasPrefix "src/" path && lib.strings.hasSuffix ".rs" path)
    (path: type: builtins.elem path [
      "Cargo.lock"
      "Cargo.toml"
      "src"
      "src/bin"
    ])
  ];
  rs = pkgs.rustPlatform.buildRustPackage {
    pname = cargoToml.package.name;
    version = cargoToml.package.version;
    src = builtins.filterSource (path: type: builtins.any (x: x (lib.strings.removePrefix (toString ./. + "/") path) type) srcFilters) ./.;
    cargoLock = {
      lockFile = ./Cargo.lock;
    };
  };
in
{
  home.packages = [ rs ];
}
