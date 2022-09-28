{ lib
, fetchFromGitHub
, ocamlPackages
, pkg-config
, libdrm
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "unstable-2022-08-06";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "fa566c85ce7f75e98d66b9fe617dcc4d565cd48a";
    sha256 = "sha256-rU3uXV/Y98248d922JTz+F5MtOALbljW2Xl4FBXhRH4=";
  };

  postPatch = ''
    # no need to vendor
    rm -r ocaml-wayland
  '';

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  strictDeps = true;
  nativeBuildInputs = [
    ocamlPackages.ppx_cstruct
    pkg-config
  ];

  buildInputs = [ libdrm ] ++ (with ocamlPackages; [
    dune-configurator
    wayland
    cmdliner
    logs
    cstruct-lwt
    ppx_cstruct
  ]);

  doCheck = true;

  meta = {
    homepage = "https://github.com/talex5/wayland-virtwl-proxy";
    description = "Proxy Wayland connections across a VM boundary";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
