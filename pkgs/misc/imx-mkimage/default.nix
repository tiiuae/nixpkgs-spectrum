{ lib, stdenv, fetchgit, git, glibc, gcc }:

stdenv.mkDerivation rec {
  pname = "imx-mkimage";
  version = "lf-5.15.32_2.0.0";

  src = fetchgit {
    url = "https://source.codeaurora.org/external/imx/imx-mkimage.git";
    rev = version;
    sha256 = "sha256-9buTYj0NdKV9CpzHfj7sIB5sRzS4Md48pn2joy+T97U=";
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
    mkdir -p $out/bin
    install -m 0755 mkimage_imx8 $out/bin
  '';
}
