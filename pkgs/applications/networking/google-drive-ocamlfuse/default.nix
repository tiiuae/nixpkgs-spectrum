{ lib, buildDunePackage, fetchFromGitHub
, ocaml_extlib, ocamlfuse, gapi-ocaml, ocaml_sqlite3
, tiny_httpd
, ounit
}:

buildDunePackage rec {
  pname = "google-drive-ocamlfuse";
  version = "0.7.30";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    sha256 = "sha256-DWG0nBiqeVHaYQfGzU43gGwL4m8X61x5/RT5jD4AwYA=";
  };

  doCheck = true;
  checkInputs = [ ounit ];

  buildInputs = [ ocaml_extlib ocamlfuse gapi-ocaml ocaml_sqlite3 tiny_httpd ];

  meta = {
    inherit (src.meta) homepage;
    description = "A FUSE-based file system backed by Google Drive, written in OCaml";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
