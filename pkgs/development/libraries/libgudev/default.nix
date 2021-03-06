{ lib, stdenv
, fetchurl
, pkg-config
, meson
, ninja
, udev
, glib
, gnome
, vala
, withIntrospection ? (stdenv.buildPlatform == stdenv.hostPlatform)
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "libgudev";
  version = "237";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1al6nr492nzbm8ql02xhzwci2kwb1advnkaky3j9636jf08v41hd";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    glib # for glib-mkenums needed during the build
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    udev
    glib
  ];

  mesonFlags = [
    # There's a dependency cycle with umockdev and the tests fail to LD_PRELOAD anyway
    "-Dtests=disabled"
    "-Dintrospection=${if withIntrospection then "enabled" else "disabled"}"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dvapi=disabled"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A library that provides GObject bindings for libudev";
    homepage = "https://wiki.gnome.org/Projects/libgudev";
    maintainers = [ maintainers.eelco ] ++ teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
