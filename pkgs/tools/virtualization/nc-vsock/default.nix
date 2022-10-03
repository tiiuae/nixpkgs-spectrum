# nc-vsock.nix by vadim.likholetov@unikie.com
let
  pkgs = import <nixpkgs> { };
in
  pkgs.stdenv.mkDerivation {
    name = "nc-vsock";

    src = ./.;

    buildPhase = ''
      $CC nc-vsock.c -o nc-vsock
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp nc-vsock  $out/bin/nc-vsock
    '';
  }
