{ lib, stdenv, fetchFromGitHub, autoreconfHook, libgcrypt, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "munge";
  version = "0.5.14";

  src = fetchFromGitHub {
    owner = "dun";
    repo = "munge";
    rev = "${pname}-${version}";
    sha256 = "15h805rwcb9f89dyrkxfclzs41n3ff8x7cc1dbvs8mb0ds682c4j";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libgcrypt zlib bzip2 ];

  preAutoreconf = ''
    # Remove the install-data stuff, since it tries to write to /var
    substituteInPlace src/Makefile.am --replace "etc \\" "\\"
  '';

  configureFlags = [
    "--localstatedir=/var"
  ];

  meta = with lib; {
    description = ''
      An authentication service for creating and validating credentials
    '';
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.rickynils ];
  };
}
