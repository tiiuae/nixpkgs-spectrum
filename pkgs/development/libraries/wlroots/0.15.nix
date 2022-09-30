{ lib, stdenv, fetchFromGitLab, meson, ninja, pkg-config, wayland-scanner
, libGL, wayland, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa
, libpng, ffmpeg_4, xcbutilrenderutil, seatd, vulkan-loader, glslang
, nixosTests, fetchpatch

, enableXWayland ? true, xwayland ? null
}:

stdenv.mkDerivation rec {
  pname = "wlroots";
  version = "0.15.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "wlroots";
    repo = "wlroots";
    rev = version;
    sha256 = "sha256-MFR38UuB/wW7J9ODDUOfgTzKLse0SSMIRYTpEaEdRwM=";
  };

  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out" "examples" ];

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner glslang ];

  buildInputs = [
    libGL wayland wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa
    libpng ffmpeg_4 xcbutilrenderutil seatd vulkan-loader
  ]
    ++ lib.optional enableXWayland xwayland
  ;

  mesonFlags =
    lib.optional (!enableXWayland) "-Dxwayland=disabled"
  ;

  patches = [
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/puckipedia/wlroots/-/commit/1f2cd76e27f19d268dec60b72e2bfdcb13cff660.patch";
      sha256 = "sha256-18/v/TTRrnDDzrGJ4ZqCsnH+wsFuAJMvgBDS+JqAjoU=";
    })
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/puckipedia/wlroots/-/commit/193e7dc6bb02ca379dc7d26ef407b8216e1fb503.patch";
      sha256 = "sha256-Z+Hi+DBVH/m1MABTzlxMLUuWMe5BFg++J9UP1mxs4z8=";
    })
  ];

  # Add the protocol here instead of in wayland-protocols for recompilation reasons
  postPatch = ''
    cp ${./security-context-v1.xml} protocol/security-context-v1.xml
    substituteInPlace protocol/meson.build \
      --replace "wl_protocol_dir / 'staging/security-context/" "'"
  '';

  postFixup = ''
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';

  # Test via TinyWL (the "minimum viable product" Wayland compositor based on wlroots):
  passthru.tests.tinywl = nixosTests.tinywl;

  meta = with lib; {
    description = "A modular Wayland compositor library";
    longDescription = ''
      Pluggable, composable, unopinionated modules for building a Wayland
      compositor; or about 50,000 lines of code you were going to write anyway.
    '';
    inherit (src.meta) homepage;
    changelog = "https://gitlab.freedesktop.org/wlroots/wlroots/-/tags/${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
