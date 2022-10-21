{ lib, stdenv,
gtk3, atk, glib, pango, gdk-pixbuf, cairo, freetype, fontconfig, dbus,
libXi, libXcursor, libXdamage, libXrandr, libXcomposite, libXext, libXfixes, libxcb,
libXrender, libX11, libXtst, libXScrnSaver, nss, nspr, alsa-lib, cups, expat, udev, libpulseaudio,
at-spi2-atk, at-spi2-core, libxshmfence, libdrm, libxkbcommon, mesa, unzip
}:

let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc gtk3 atk glib pango gdk-pixbuf cairo freetype fontconfig dbus
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes libxcb
    libXrender libX11 libXtst libXScrnSaver nss nspr alsa-lib cups expat udev libpulseaudio
    at-spi2-atk at-spi2-core libxshmfence libdrm libxkbcommon mesa
  ];

in stdenv.mkDerivation rec {
  name = "gala";

  nativeBuildInputs = [ unzip ];

  buildInputs = [ unzip ];

  src = ./dev.scpp.saca.gala-0.0.1.zip;
  phases = "unpackPhase fixupPhase";
  targetPath = "$out/gala";
  intLibPath = "$out/gala/swiftshader";

  unpackPhase = ''
    mkdir -p ${targetPath}
    unzip $src -d ${targetPath}
  '';

  rpath = lib.concatStringsSep ":" [
    libPath
    targetPath
    intLibPath
  ];

  fixupPhase = ''
    patchelf \
      --set-interpreter "${dynamic-linker}" \
      --set-rpath "${rpath}" \
      ${targetPath}/dev.scpp.saca.gala

    mkdir -p $out/bin
    ln -s $out/gala/dev.scpp.saca.gala $out/bin/gala
  '';
}