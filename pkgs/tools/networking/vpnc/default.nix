{ lib, stdenv, fetchFromGitHub, fetchpatch, buildPackages
, makeWrapper, pkg-config, perl
, gawk, gnutls, libgcrypt, openresolv, vpnc-scripts
, opensslSupport ? false, openssl # Distributing this is a GPL violation.
}:

stdenv.mkDerivation {
  pname = "vpnc-unstable";
  version = "2021-01-31";

  src = fetchFromGitHub {
    owner = "streambinder";
    repo = "vpnc";
    rev = "43780cecd7a61668002f73b6f8b9f9ba61af74ad";
    sha256 = "1sbnvp8117qiklc5xghdhx2i310p5wgjgjg7dr6xj48i167ks1zv";
    fetchSubmodules = true;
  };

  patches = [
    # Use pkg-config to find libgcrypt, fixing cross.
    (fetchpatch {
      url = "https://github.com/streambinder/vpnc/commit/f1efcfc9824944370de2fc4ac46dc4292ddbecea.patch";
      sha256 = "13kxp2147q4jz98p5qqmj32mg15lb02jdz5j4lfjgvlmbz133q4h";
    })
    # Don't do networking during build.
    (fetchpatch {
      url = "https://github.com/streambinder/vpnc/commit/9f4e3ab1f51c8c5ff27b8290f5a533a87d85c011.patch";
      sha256 = "1h029954q9qy2kcrj6dzprgrjvr12lk96yy8dgva9nr4ghidy18a";
    })
  ];

  nativeBuildInputs = [ makeWrapper perl ]
    ++ lib.optional (!opensslSupport) pkg-config;
  buildInputs = [ libgcrypt perl ]
    ++ (if opensslSupport then [ openssl ] else [ gnutls ]);

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=$(out)/etc/vpnc"
    "SCRIPT_PATH=${vpnc-scripts}/bin/vpnc-script"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "VPNC=${buildPackages.vpnc}/bin/vpnc"
  ] ++ lib.optional opensslSupport "OPENSSL_GPL_VIOLATION=yes";

  postPatch = ''
    patchShebangs src/makeman.pl
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://davidepucci.it/doc/vpnc/";
    description = "Virtual private network (VPN) client for Cisco's VPN concentrators";
    license = if opensslSupport then licenses.unfree else licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
