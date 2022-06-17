{ unstable }:

[
  (self: super: {
    rust-analyzer = unstable.rust-analyzer; # required to work properly with new Cargo versions
  })
  # https://github.com/flameshot-org/flameshot/issues/2302
  (self: super: {
    flameshot = assert builtins.compareVersions super.flameshot.version "11.0.0" == 0; super.flameshot.overrideAttrs (old: {
      version = "unstable-2022-02-18";
      src = super.fetchFromGitHub {
        owner = "flameshot-org";
        repo = "flameshot";
        rev = "aa6b5eac93ee92b58c5ead9404f60a760f667980";
        sha256 = "0dckspmzyakn68r84j58njl73n5k662d0p6517v5jmwcqm3qrrkm";
      };
    });
  })
  # https://github.com/kovidgoyal/kitty/issues/5153
  (self: super: {
    kitty = assert builtins.compareVersions super.kitty.version "0.25.1" != 1; super.kitty.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (super.fetchpatch {
          name = "combining-char-rendering.patch";
          url = "https://github.com/kovidgoyal/kitty/commit/e12a9f3caf71cd8d96c7d81314d1888156f37a54.patch";
          sha256 = "sha256-EBKtMkkcWjc2KGtw9vr5KY9CC3bvDP1eHh/D2odxI/Q=";
        })
      ];
    });
  })
  (self: super: {
    direnv = super.direnv.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./patches/direnv-0001-reduce-verbosity.patch
      ];
    });
    kitty = super.kitty.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./patches/kitty-0001-sound-theme.patch
      ];
    });
  })
  (self: super: {
    some = super.rustPlatform.buildRustPackage {
      pname = "some";
      version = "0.1.0";
      src = super.fetchFromGitHub {
        owner = "sersorrel";
        repo = "some.rs";
        rev = "1e24bff9b2b8ef09ea69d82f40a3da6b07dc1d38";
        sha256 = "17z113zka3id1s7p59rq54y2whk9ah3pbnyazhm9x7lzq34d02va";
      };
      cargoSha256 = "0706n3939aqz1h5b3g1ipdni29nsbwyiycna2qhns6dwxj6fm9sk";
      meta = with super.lib; {
        description = "a meta-pager";
        homepage = "https://github.com/sersorrel/some.rs";
      };
    };
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
    file2img = super.callPackage ./programs/file2img/file2img.nix {};
  })
  (self: super: {
    rhythmbox = super.rhythmbox.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./patches/rhythmbox-0001-no-pause-notification.patch
      ];
    });
  })
  (self: super: {
    i3status-rust = super.i3status-rust.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./patches/i3status-rust-0001-uptime-warning.patch
        ./patches/i3status-rust-0002-kdeconnect-zero-battery.patch
        ./patches/i3status-rust-0003-kdeconnect-disconnected-idle.patch
      ];
    });
  })
]
