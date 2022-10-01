# nc-vsock.nix by vadim.likholetov@unikie.com
{ lib,stdenv }:
  stdenv.mkDerivation  {
    pname = "nc-vsock";
    version = "0.1";

    src = ./.;

    buildPhase = ''
      $CC nc-vsock.c -o nc-vsock
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp nc-vsock  $out/bin/nc-vsock
    '';
  }
