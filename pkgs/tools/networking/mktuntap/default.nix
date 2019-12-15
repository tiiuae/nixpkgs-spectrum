{ stdenv, lib, fetchgit }:

stdenv.mkDerivation rec {
  pname = "mktuntap";
  version = "1.0";

  src = fetchgit {
    url = "https://spectrum-os.org/git/mktuntap";
    rev = version;
    sha256 = "136ichzd5811n289xqjyha81mln89yxq4a14w46ixnnx69905r47";
  };

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Utility program for creating TAP and TUN devices";
    homepage = "https://spectrum-os.org/git/mktaptun";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl2;
    platform = platforms.linux;
  };
}
