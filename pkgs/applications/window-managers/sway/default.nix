{ lib, stdenv, fetchFromGitHub, substituteAll, swaybg
, meson, ninja, pkg-config, wayland-scanner, scdoc
, wayland, libxkbcommon, pcre, json_c, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf, librsvg
, wlroots, wayland-protocols, libdrm
, nixosTests
, fetchpatch
# Used by the NixOS module:
, isNixOS ? false

, enableXWayland ? true
, systemdSupport ? stdenv.isLinux
, dbusSupport ? true
, dbus
, trayEnabled ? systemdSupport && dbusSupport
}:

# The "sd-bus-provider" meson option does not include a "none" option,
# but it is silently ignored iff "-Dtray=disabled".  We use "basu"
# (which is not in nixpkgs) instead of "none" to alert us if this
# changes: https://github.com/swaywm/sway/issues/6843#issuecomment-1047288761
assert trayEnabled -> systemdSupport && dbusSupport;
let sd-bus-provider = if systemdSupport then "libsystemd" else "basu"; in

stdenv.mkDerivation rec {
  pname = "sway-unwrapped";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = version;
    sha256 = "0ss3l258blyf2d0lwd7pi7ga1fxfj8pxhag058k7cmjhs3y30y5l";
  };

  patches = [
    ./load-configuration-from-etc.patch

    (substituteAll {
      src = ./fix-paths.patch;
      inherit swaybg;
    })

    (fetchpatch {
      url = "https://github.com/puckipedia/sway/commit/6b45b7dbc03f5f0184ab0f45d36690df1cc869bd.patch";
      sha256 = "sha256-LxW+02eTsm/XeKCwhyQfF6FlVVBsdTsybJi7nM4vahI=";
    })
    (fetchpatch {
      url = "https://github.com/puckipedia/sway/commit/f7733c0444b9cc55fbbce20259db4fc97168827a.patch";
      sha256 = "sha256-+Dsbfwh6+a6j+srMszisRTSsM6U99iG+4eHIz01qGkQ=";
    })
    (fetchpatch {
      url = "https://github.com/puckipedia/sway/commit/683caa484c993d8d46c703f1d18beb2000f6a302.patch";
      sha256 = "sha256-zTXAveiTfIDp96GmuKx+lWpGTjNexGOCzLxfgKEt8KQ=";
    })
    (fetchpatch {
      url = "https://github.com/puckipedia/sway/commit/2e769c16e69eedd410372c37bf2492d982689488.patch";
      sha256 = "sha256-4Ap9C9bKqaYxbkYB0pBkywqvsYyYTf3wUYgKClfEkRE=";
    })
    (fetchpatch {
      url = "https://github.com/puckipedia/sway/commit/4ec88a243661f0cf53ede8d354b533a57cfe2208.patch";
      sha256 = "sha256-g9Ua8RdHzEVgw+KbnJkzHvSD2HVOybpOdPhUw3cCPyY=";
    })
  ] ++ lib.optionals (!isNixOS) [
    # References to /nix/store/... will get GC'ed which causes problems when
    # copying the default configuration:
    ./sway-config-no-nix-store-references.patch
  ] ++ lib.optionals isNixOS [
    # Use /run/current-system/sw/share and /etc instead of /nix/store
    # references:
    ./sway-config-nixos-paths.patch
  ];

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson ninja pkg-config wayland-scanner scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre json_c libevdev
    pango cairo libinput libcap pam gdk-pixbuf librsvg
    wayland-protocols libdrm
    (wlroots.override { inherit enableXWayland; })
  ] ++ lib.optionals dbusSupport [
    dbus
  ];

  mesonFlags =
    [ "-Dsd-bus-provider=${sd-bus-provider}" ]
    ++ lib.optional (!enableXWayland) "-Dxwayland=disabled"
    ++ lib.optional (!trayEnabled)    "-Dtray=disabled"
  ;

  passthru.tests.basic = nixosTests.sway;

  meta = with lib; {
    description = "An i3-compatible tiling Wayland compositor";
    longDescription = ''
      Sway is a tiling Wayland compositor and a drop-in replacement for the i3
      window manager for X11. It works with your existing i3 configuration and
      supports most of i3's features, plus a few extras.
      Sway allows you to arrange your application windows logically, rather
      than spatially. Windows are arranged into a grid by default which
      maximizes the efficiency of your screen and can be quickly manipulated
      using only the keyboard.
    '';
    homepage    = "https://swaywm.org";
    changelog   = "https://github.com/swaywm/sway/releases/tag/${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
