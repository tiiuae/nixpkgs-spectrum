{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, pytest }:

buildPythonPackage rec {
  pname = "eth-typing";
  version = "3.0.0";

  # Tests are missing from the PyPI source tarball so let's use GitHub
  # https://github.com/ethereum/eth-typing/issues/8
  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9rrnDFPWAmrUkr2mVTVi/8DTJdg4hzGaU0UbpwG5mtY=";
  };

  # setuptools-markdown uses pypandoc which is broken at the moment
  preConfigure = ''
    substituteInPlace setup.py --replace \'setuptools-markdown\' ""
  '';

  disabled = pythonOlder "3.5";

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest .
  '';

  meta = {
    description = "Common type annotations for Ethereum Python packages";
    homepage = "https://github.com/ethereum/eth-typing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
