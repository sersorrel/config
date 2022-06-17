{ stdenv
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, writeShellScript
, dbus
, fetchurl
, fontconfig
, freetype
, glib
, lib
, libGL
, libffi
, libxkbcommon_7
, openssl
, pulseaudio
, sqlite
, udev
, xorg
, xz
, zlib
, srcs ? null
}:

assert srcs != null;
stdenv.mkDerivation rec {
  pname = "talon-beta";
  inherit (srcs) version;
  src = fetchurl {
    inherit (srcs) url sha256;
  };

  nativeBuildInputs = [
    # NB: we are careful *not* to use qt5.wrapQtAppsHook here, since Talon has its own bundled Qt
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    dbus
    fontconfig
    freetype
    glib
    libGL
    libffi
    libxkbcommon_7
    openssl
    pulseaudio
    sqlite
    stdenv.cc.cc
    stdenv.cc.libc
    udev
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXrender
    xorg.libxcb
    xz
    zlib
  ];

  libPath = "${placeholder "out"}/lib/talon/lib:"
    + "${placeholder "out"}/lib/talon/resources/python/lib:"
    + "${placeholder "out"}/lib/talon/resources/python/lib/python3.9/site-packages/numpy.libs:"
    + lib.makeLibraryPath buildInputs;

  # Avoid errors like "ImportError: libgfortran-2e0d59d6.so.5.0.0: ELF load command address/offset not properly aligned".
  # Possibly related: https://github.com/pypa/manylinux/issues/119
  dontStrip = true;
  # See also: https://github.com/NixOS/nixpkgs/issues/15969
  dontPatchELF = true;

  # TODO: parts of this should probably be in postFixup instead
  installPhase = ''
    runHook preInstall

    # Clean out unused stuff
    rm run.sh
    rm 10-talon.rules

    # Copy Talon to the Nix store
    mkdir -p $out/lib/talon-beta
    cp --recursive --target-directory=$out/lib/talon-beta *

    # Tell Talon and the bundled Python where to find glibc
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$libPath" \
      $out/lib/talon-beta/talon
    # The bundled Python already has an RPATH ($ORIGIN/../lib) to help it find libpython, we need to preserve that.
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$(patchelf --print-rpath $out/lib/talon-beta/resources/python/bin/python3):$libPath" \
      $out/lib/talon-beta/resources/python/bin/python3

    wrapProgram "$out/lib/talon-beta/talon" \
      --unset QT_AUTO_SCREEN_SCALE_FACTOR \
      --unset QT_SCALE_FACTOR \
      --set   LC_NUMERIC C \
      --set   QT_PLUGIN_PATH "$out/lib/talon-beta/lib/plugins" \
      --set   LD_LIBRARY_PATH "$out/lib/talon-beta/lib:$out/lib/talon-beta/resources/python/lib:$out/lib/talon-beta/resources/pypy/lib:${libPath}"

    mkdir -p $out/bin
    ln -s "$out/lib/talon-beta/talon" "$out/bin/talon-beta"
    ln -s ${writeShellScript "talon-repl" ''exec ~/.talon/bin/repl "$@"''} $out/bin/talon-beta-repl
    wrapProgram $out/bin/talon-beta-repl \
      --set   LD_LIBRARY_PATH "$out/lib/talon-beta/lib:$out/lib/talon-beta/resources/python/lib:$out/lib/talon-beta/resources/pypy/lib:${libPath}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "talon-beta";
      desktopName = "Talon (beta)";
      exec = "talon-beta";
    })
  ];

  meta = with lib; {
    description = "Powerful hands-free input";
    homepage = "https://talonvoice.com";
    license = licenses.unfree; # https://talonvoice.com/EULA.txt
    platforms = platforms.linux;
  };
}
