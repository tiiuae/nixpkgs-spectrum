{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghz";
  version = "0.110.0";

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${version}";
    sha256 = "sha256-lAQGog45COrS2a5ZmFZEDERdZt24DnVSkPz49txqFmo=";
  };

  vendorSha256 = "sha256-VjrSUP0SwE5iOTevqIGlnSjH+TV4Ajx/PKuco9etkSc=";

  subPackages = [ "cmd/ghz" "cmd/ghz-web" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = licenses.asl20;
    maintainers = [ maintainers.zombiezen ];
  };
}
