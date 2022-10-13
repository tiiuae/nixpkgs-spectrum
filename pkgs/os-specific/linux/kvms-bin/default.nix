{ lib, stdenv, fetchFromGitHub, kernel }:

let
  chipset = "----Please.set.chipset.through.overrideAttrs----";
in

stdenv.mkDerivation ({
    inherit chipset;

    name = "kvms";
    installPhase = ''
      mkdir $out
      cp ./platform/nxp/$chipset/"${kernel.version}"/bl1.bin $out/
    '';

    src = fetchFromGitHub {
      owner = "grihey";
      repo = "kvms_bin";
      rev = "83d97c29";
      sha256 = "1fj6auOrXpWRVax4gXX4rG06izOZ9owNSN17WN14VRw=";
    };
})
