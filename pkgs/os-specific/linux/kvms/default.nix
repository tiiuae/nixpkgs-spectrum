{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation ({

    name = "kvms";

    src = fetchFromGitHub {
      owner = "grihey";
      repo = "kvms_bin";
      rev = "10f9be75";
      sha256 = "/f6Ve5XxpvQBHH98vkMMBSD7IP8XlKu7Y8+AUjzfNpg=";
    };
})
