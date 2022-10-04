{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, sassc
, gdk-pixbuf
, librsvg
, gtk-engine-murrine
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "greybird";
  version = "3.23.2";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "h4sPjKpTufaunVP0d4Z5x/K+vRW1FpuLrMJjydx/a6w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  passthru.updateScript = gitUpdater { inherit pname version; rev-prefix = "v"; };

  meta = with lib; {
    description = "Grey and blue theme from the Shimmer Project for GTK-based environments";
    homepage = "https://github.com/shimmerproject/Greybird";
    license = [ licenses.gpl2Plus ]; # or alternatively: cc-by-nc-sa-30 or later
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
