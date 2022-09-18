{ unstable, here }:

let
  localPath = path: let
    inherit (builtins) stringLength substring;
    # careful here, otherwise we accidentally start copying things to the store (which fails because of the @ in the path)
    path' = toString path;
    this' = toString ./.;
    pathLen = stringLength path';
    thisLen = stringLength this';
  in assert substring 0 thisLen path' == this'; here + (substring thisLen pathLen path');
in
[
  # https://github.com/garabik/unicode/pull/21
  (self: super: {
    unicode-paracode = assert builtins.compareVersions super.unicode-paracode.version "2.9" != 1; super.unicode-paracode.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (super.fetchpatch {
          name = "show-unicode1-name-as-fallback.patch";
          url = "https://github.com/garabik/unicode/pull/21/commits/2c11b705810a5a3a927e2b36ed6d32ce2867a6f7.patch";
          sha256 = "sha256-cVBXnsi7FGXki7woJj09k8joyP1695HsOTWktPtFg1c=";
        })
      ];
    });
  })
  (self: super: {
    direnv = super.direnv.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (localPath ./patches/direnv-0001-reduce-verbosity.patch)
      ];
    });
    kitty = super.kitty.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (localPath ./patches/kitty-0001-sound-theme.patch)
      ];
    });
    rink = super.rink.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (localPath ./patches/rink-0001-change-date-formats.patch)
        (localPath ./patches/rink-0002-amp-hour.patch)
      ];
    });
  })
  (self: super: {
    uoyweek = super.rustPlatform.buildRustPackage {
      pname = "uoyweek";
      version = "0.1.0";
      src = super.fetchFromGitHub {
        owner = "sersorrel";
        repo = "uoyweek.rs";
        rev = "d32e4096dee51641270cb4b624d7b0727f101f42";
        sha256 = "17a2173myj6fxmgyaly6nz905b94vw6zr8qm5v2ig7yrxlqd9nnk";
      };
      cargoSha256 = "1xfgszxbj1ji0wpz01n9hhwnba7kxbbqk53r0sgxasxbzfmmknw5";
    };
  })
  (self: super: {
    display-volume = super.rustPlatform.buildRustPackage {
      pname = "display-volume";
      version = "0.1.0";
      src = super.fetchFromGitHub {
        owner = "sersorrel";
        repo = "display-volume";
        rev = "318a70933869d3a5c50bce06bda2887c3c287e84";
        sha256 = "1gqyxggxwk87ddcsisb4s1rw8f9z8lyxg95py0nn77q18w6f6srg";
      };
      cargoSha256 = "1a8rm1hnw7gmbvaps9p0kcr3v0vm7a0ax31qcfsghhl3nckr4nkm";
      nativeBuildInputs = [
        super.autoPatchelfHook
      ];
      buildInputs = [
        super.libpulseaudio
      ];
    };
  })
  (self: super: {
    file2img = super.callPackage (localPath ./programs/file2img/file2img.nix) {};
  })
  (self: super: {
    rhythmbox = super.rhythmbox.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (localPath ./patches/rhythmbox-0001-no-pause-notification.patch)
      ];
    });
  })
  (self: super: {
    i3status-rust = super.i3status-rust.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (localPath ./patches/i3status-rust-0001-uptime-warning.patch)
        (localPath ./patches/i3status-rust-0002-kdeconnect-zero-battery.patch)
        (localPath ./patches/i3status-rust-0003-kdeconnect-disconnected-idle.patch)
      ];
    });
  })
]
