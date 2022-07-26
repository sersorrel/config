{ stdenv
, autoPatchelfHook
, copyDesktopItems
, dbus
, fontconfig
, freetype
, libGL
, libxkbcommon
, makeDesktopItem
, makeWrapper
, ncurses6
, requireFile
, unzip
, xorg
, zlib
}:

stdenv.mkDerivation {
  pname = "binary-ninja";
  version = "3.1.3469";

  src = requireFile rec {
    name = "BinaryNinja-personal.zip";
    url = "https://binary.ninja/recover/";
    sha256 = "1fyc629vxnda6sap32nw5k3ikq1mjnaw6vzxgynj4hz86nf0xaik";
    message = ''
      Stable download URLs for Binary Ninja are not available.
      Please visit ${url} and find the download link for ${name},
      then add it to the Nix store with this command:

        nix-prefetch-url --name ${name} --type sha256 <URL>
    '';
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
    unzip
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
