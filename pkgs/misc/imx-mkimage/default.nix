{ lib, stdenv, fetchgit, git, glibc, gcc }:

stdenv.mkDerivation rec {
  pname = "imx-mkimage";
  version = "lf-5.15.32-2.0.0";

  src = fetchgit {
    url = "https://source.codeaurora.org/external/imx/imx-mkimage.git";
    rev = version;
    sha256 = "sha256-31pib5DTDPVfiAAoOSzK8HWUlnuiNnfXQIsxbjneMCc=";
    leaveDotGit = true;
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
