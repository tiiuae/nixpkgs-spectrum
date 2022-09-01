{ lib, fetchurl, fetchpatch }:

rec {
  version = "3.2.5";
  src = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    sha256 = "sha256-KsTSFjXN95GGe8N3w1ym3af1DZGaWL5FBX/VFgDGmro=";
  };
  upstreamPatchTarball = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/rsync-patches-${version}.tar.gz";
    sha256 = "sha256-57H98fwPymj9JUJGwtwE9qyQJB5mXc+d/CHczYJwtrs=";
  };

  meta = with lib; {
    description = "Fast incremental file transfer utility";
    homepage = "https://rsync.samba.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
