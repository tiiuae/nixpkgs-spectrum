{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation ({

    name = "kvms";

    src = fetchFromGitHub {
      owner = "grihey";
      repo = "kvms_bin";
      rev = "110b733";
      sha256 = "UDO7WloCfxstKUh6xQv6PAi/Z5hWEshTeNtyhObrYR4=";
    };
})
