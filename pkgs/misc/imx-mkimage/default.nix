{ lib, stdenv, fetchgit, git, glibc, gcc }:

stdenv.mkDerivation rec {
  pname = "imx-mkimage";
  version = "lf-5.15.32_2.0.0";

  src = fetchgit {
    url = "https://source.codeaurora.org/external/imx/imx-mkimage.git";
    rev = "a8bb8edb45492ac70b33734122a57aa8e38a20bd";
    sha256 = "sha256-jdmAvmjoWZ1wtpBNX4cF0f2k7lIGjkmoj+SSLGbNq9M=";
  };

  patches = [
    ./fix-gcc-for-nix.patch
  ];

  nativeBuildInputs = [
    git
  ];

  buildInputs = [
    gcc
    glibc.static
  ];

  makeFlags = [
    "bin"
  ];

  installPhase = ''
    install -m 0755 mkimage_imx8 $out
  '';
}
