# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "python37-docs-html";
  version = "3.7.2";

  src = fetchurl {
    url = "http://docs.python.org/ftp/python/doc/${version}/python-${version}-docs-html.tar.bz2";
    sha256 = "19wbrawpdam09fmyipfy92sxwn1rl93v8jkfqsfx028qhvzf0422";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python37
    cp -R ./ $out/share/doc/python37/html
  '';
  meta = {
    maintainers = [ ];
  };
}
