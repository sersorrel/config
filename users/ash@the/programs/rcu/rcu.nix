# based on https://github.com/rvl/pkg-rcu

{ copyDesktopItems
, fetchzip
, lib
, makeDesktopItem
, python3Packages
, libxkbcommon
, libXinerama
, pkgconfig
, qt5
, xorg
, srcs ? null
}:

assert srcs != null;
python3Packages.buildPythonApplication rec {
  pname = "rcu";
  inherit (srcs) version;
  src = fetchzip {
    inherit (srcs) url sha256;
  };

  format = "pyproject";

  nativeBuildInputs = [
    copyDesktopItems
    pkgconfig
    python3Packages.pyside2-tools
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    python3Packages.pyside2-tools
  ];

  propagatedBuildInputs = [
    xorg.libxcb
    xorg.xcbproto
    xorg.xcbutil
    xorg.xcbutilwm
    xorg.libXinerama
    libxkbcommon
    libXinerama

    python3Packages.certifi
    python3Packages.pyside2
    python3Packages.paramiko
    python3Packages.pdfrw
    python3Packages.qtpy
    python3Packages.pillow
  ];

  patches = [
    ./0001-paths.patch
    ./0002-scoping.patch
  ];
  postPatch = ''
    # Fix the top-level directory name
    mv src rcu
    sed -i s/src/rcu/g Makefile rcu/rcu.py

    # Add pyproject.toml and setup.cfg for buildPythonApplication
    cat >pyproject.toml <<"EOF"
    [build-system]
    requires = ["setuptools", "wheel"]
    build-backend = "setuptools.build_meta"
    EOF
    cat >setup.cfg <<"EOF"
    [metadata]
    name = ${pname}
    version = ${version}
    [options]
    packages =
      rcu
      rcu.controllers
      rcu.model
      rcu.model.pens
      rcu.panes
      rcu.panes.about
      rcu.panes.deviceinfo
      rcu.panes.deviceinfo.backup
      rcu.panes.display
      rcu.panes.incompatible
      rcu.panes.notebooks
      rcu.panes.software
      rcu.panes.splash
      rcu.panes.templates
    install_requires =
      paramiko >= 2.7.1
      pdfrw >= 0.4
      Pillow >= 8.0.1
    zip_safe = False
    [options.entry_points]
    console_scripts =
      rcu = rcu.main:main
    [options.package_data]
    rcu =
      version.txt
      licenses/*
      views/*
    rcu.model.pens =
      pencil_textures_linear/*
      pencil_textures_log/*
      paintbrush_textures_log/*
    * =
      *.ui
      icons/*
    EOF
  '';

  postInstall = ''
    for size in 64 128 256 512; do
      name="''${size}x$size"
      target=$out/share/icons/hicolor/$name/apps
      prefix=$src/icons/$name/rcu-icon-$name
      for fmt in png svg; do
        install -D $prefix.$fmt $target/rcu.$fmt
        test -f $prefix-withpen.$fmt && install -D $prefix-withpen.$fmt $target/rcu-withpen.$fmt || true
      done
    done
  '';

  # Prevent double-wrapping with Python and Qt
  # https://nixos.org/manual/nixpkgs/stable/#ssec-gnome-common-issues-double-wrapped
  dontWrapQtApps = true;
  preFixup = ''
    # Add QT wrapper args to Python wrapper args
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rcu";
      desktopName = "RCU";
      exec = "rcu";
      icon = "rcu";
    })
  ];

  meta = with lib; {
    homepage = "http://www.davisr.me/projects/rcu/";
    description = "All-in-one offline/local management software for reMarkable e-paper tablets.";
    license = licenses.agpl3;
  };
}
