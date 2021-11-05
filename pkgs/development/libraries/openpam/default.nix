{ lib, stdenv, fetchFromGitea, autoreconfHook, perl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "openpam";
  version = "20190224";

  src = fetchFromGitea {
    domain = "git.des.dev";
    owner = "OpenPAM";
    repo = "OpenPAM";
    rev = "openpam-${version}";
    sha256 = "03jxfpl30aw8x8nmir00cl21abm2h9kjvg5q3ipxiwlffndjiny0";
  };

  nativeBuildInputs = [ autoreconfHook perl pkg-config ];

  meta = with lib; {
    homepage = "https://www.openpam.org";
    description = "An open source PAM library that focuses on simplicity, correctness, and cleanliness";
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.bsd3;
  };
}
