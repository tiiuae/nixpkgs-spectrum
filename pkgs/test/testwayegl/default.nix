{ lib, stdenv, pkg-config, fetchurl,  unzip, autoconf, automake, wayland }:
 stdenv.mkDerivation {
  name = "testwayegl";
  
  nativeBuildInputs = [ unzip pkg-config autoconf automake wayland];

  builder = builtins.toFile "builder.sh" "
    source $stdenv/setup
    echo ---------
    ls -lR
    echo ---------
    unzip  $src
    cd test-wayland-egl-master
    autoreconf -i
    ./configure --prefix=$out
    make
    make install
  ";

  src = fetchurl {
    url = "https://github.com/ashie/test-wayland-egl/archive/refs/heads/master.zip";
    sha256 = "sha256-3E28H1xY0ozw5J0Dct4dLlB/gKHPf2lOgL/WVBe1T9s=";
  };
}
