{ stdenv
, autoPatchelfHook
, copyDesktopItems
, dbus
, fetchzip
, fontconfig
, freetype
, libGL
, libxkbcommon
, makeDesktopItem
, makeWrapper
, ncurses6
, xorg
, zlib
, src ? null
}:

stdenv.mkDerivation {
  pname = "binary-ninja";
  version = src.version;

  src = fetchzip {
    inherit (src) url sha256;
    extension = "zip";
  };

  buildInputs = [
    dbus # libdbus-1.so.3
    fontconfig.lib # libfontconfig.so.1
    freetype # libfreetype.so.6
    libGL # libGL.so.1
    libxkbcommon # libxkbcommon.so.0
    ncurses6 # libncurses.so.6
    stdenv.cc.cc.lib # libstdc++.so.6
    xorg.libxcb # libxcb-glx.so.0
    xorg.xcbutilimage # libxcb-image.so.0
    xorg.xcbutilkeysyms # libxcb-keysyms.so.1
    xorg.xcbutilrenderutil # libxcb-keysyms.so.1
    xorg.xcbutilwm # libxcb-icccm.so.4
    zlib # libz.so.1
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  prePatch = ''
    addAutoPatchelfSearchPath $out/opt
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r * $out/opt
    chmod +x $out/opt/binaryninja

    mkdir -p $out/share/pixmaps
    cp docs/img/logo.png $out/share/pixmaps/binary-ninja.png

    mkdir -p $out/bin
    makeWrapper $out/opt/binaryninja $out/bin/binaryninja

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libQt6Qml.so.6"
    "libQt6PrintSupport.so.6"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "binary-ninja";
      desktopName = "Binary Ninja";
      icon = "binary-ninja";
      exec = "binaryninja";
    })
  ];
}
