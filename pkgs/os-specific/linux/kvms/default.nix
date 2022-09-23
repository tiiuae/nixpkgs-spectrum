{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation ({

    name = "kvms";

    src = fetchFromGitHub {
      owner = "grihey";
      repo = "kvms_bin";
      rev = "83d97c29";
      sha256 = "1fj6auOrXpWRVax4gXX4rG06izOZ9owNSN17WN14VRw=";
    };
})
