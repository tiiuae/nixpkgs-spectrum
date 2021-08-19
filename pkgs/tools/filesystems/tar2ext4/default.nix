{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tar2ext4-unstable";
  version = "2021-10-20";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "hcsshim";
    rev = "60b5fa7eea6f95295888d71b0621eb1c1291fb67";
    sha256 = "0g5bj99786pwms7zklh3i8hvxg3dqsb5nrbqf8aifr3kp2cn9njh";
  };

  sourceRoot = "source/cmd/tar2ext4";
  vendorSha256 = null;

  meta = with lib; {
    description = "Convert a tar archive to an ext4 image";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.mit;
  };
}
