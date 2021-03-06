{ lib
, stdenv
, fetchurl
, pkg-config
, sg3_utils
, udev
, glib
, dbus
, dbus-glib
, polkit
, parted
, lvm2
, libatasmart
, intltool
, libuuid
, mdadm
, libxslt
, docbook_xsl
, util-linux
, libgudev
}:

stdenv.mkDerivation rec {
  pname = "udisks";
  version = "1.0.5";

  src = fetchurl {
    url = "https://hal.freedesktop.org/releases/udisks-${version}.tar.gz";
    sha256 = "0wbg3jrv8limdgvcygf4dqin3y6d30y9pcmmk711vq571vmq5v7j";
  };

  patches = [ ./purity.patch ./no-pci-db.patch ./glibc.patch ];

  preConfigure =
    ''
      configureFlagsArray+=(--with-systemdsystemunitdir=$out/lib/systemd/system)
    '';

  postPatch =
    ''
      sed -e 's,/sbin/mdadm,${mdadm}&,g' -e "s,@slashlibdir@,$out/lib,g" -i data/80-udisks.rules

      substituteInPlace src/main.c --replace \
        "/sbin:/bin:/usr/sbin:/usr/bin" \
        "${util-linux}/bin:${mdadm}/sbin:/run/current-system/sw/bin:/run/current-system/sw/bin"
    '';

  buildInputs =
    [
      sg3_utils
      udev
      glib
      dbus
      dbus-glib
      polkit
      parted
      libgudev
      lvm2
      libatasmart
      intltool
      libuuid
      libxslt
      docbook_xsl
    ];

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [ "--localstatedir=/var" "--enable-lvm2" ];

  meta = with lib; {
    homepage = "http://www.freedesktop.org/wiki/Software/udisks";
    description = "A daemon and command-line utility for querying and manipulating storage devices";
    platforms = platforms.linux;
    license = with licenses; [ gpl2 lgpl2Plus ];
    broken = true;
    hydraPlatforms = [ ];
  };
}
