{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libzen, zlib }:

stdenv.mkDerivation rec {
  version = "22.03";
  pname = "libmediainfo";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    sha256 = "sha256-/FC6u2KOnPumVSiNrgbVw0Kw1+aUGjLWT7uxEySMgLk=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ zlib ];
  propagatedBuildInputs = [ libzen ];

  postPatch = "cd Project/GNU/Library";

  configureFlags = [ "--enable-shared" ];

  enableParallelBuilding = true;

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = with lib; {
    description = "Shared library for mediainfo";
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
