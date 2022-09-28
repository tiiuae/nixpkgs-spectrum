{ lib
, buildDunePackage
, fetchFromGitHub
, xmlm
, lwt
, logs
, fmt
, cstruct
, cmdliner
, alcotest-lwt
}:

buildDunePackage rec {
  pname = "wayland";
  version = "unstable-2022-05-07";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "talex5";
    repo = "ocaml-wayland";
    rev = "1513420d35f3edb6ad2d9e1db0227e3cd9b9b76c";
    sha256 = "sha256-UAomnvpIuf3V8vtxvGgxuTYoxsDxFDa4UXMbXYDkSIE=";
  };

  propagatedBuildInputs = [
    lwt
    logs
    fmt
    cstruct
  ];

  buildInputs = [
    cmdliner
    xmlm
  ];

  checkInputs = [
    alcotest-lwt
  ];
  doCheck = true;

  meta = {
    description = "Pure OCaml Wayland protocol library";
    homepage = "https://github.com/talex5/ocaml-wayland";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sternenseemann ];
    mainProgram = "wayland-scanner-ocaml";
  };
}
