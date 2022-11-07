{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nc-vsock";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "vadika";
    repo = "nc-vsock";
    sha256 = "sha256-NzL2dfdDaj9WgYQkavl382G4p5j/ewMS6Di4PdcoGIg=";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
  };

  # nativeBuildInputs = [ make ];

  meta = with lib; {
    description = "Netcat with VSOCKs";
    homepage = "https://github.com/vadika/nc-vsock";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
