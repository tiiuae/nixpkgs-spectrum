{ lib, python3Packages }:

let
  truffleHogRegexes = python3Packages.buildPythonPackage rec {
    pname = "truffleHogRegexes";
    version = "0.0.7";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "b81dfc60c86c1e353f436a0e201fd88edb72d5a574615a7858485c59edf32405";
    };
  };
in
  python3Packages.buildPythonApplication rec {
    pname = "truffleHog";
    version = "2.2.1";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-fw0JyM2iqQrkL4FAXllEozJdkKWELS3eAURx5NZcceQ=";
    };

    # Relax overly restricted version constraint
    postPatch = ''
      substituteInPlace setup.py --replace "GitPython ==" "GitPython >= "
    '';

    propagatedBuildInputs = [ python3Packages.GitPython truffleHogRegexes ];

    # Test cases run git clone and require network access
    doCheck = false;

    meta = {
      homepage = "https://github.com/dxa4481/truffleHog";
      description = "Searches through git repositories for high entropy strings and secrets, digging deep into commit history";
      license = with lib.licenses; [ gpl2 ];
      maintainers = with lib.maintainers; [ bhipple ];
    };
  }
