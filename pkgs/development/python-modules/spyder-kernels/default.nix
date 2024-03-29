{ lib, buildPythonPackage, fetchPypi, cloudpickle, ipykernel, wurlitzer,
  jupyter-client, pyzmq }:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7luJo7S/n88jDJRhJx1WuF5jhmeRHrrdxinbBbXuRxc=";
  };

  propagatedBuildInputs = [
    cloudpickle
    ipykernel
    wurlitzer
    jupyter-client
    pyzmq
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "ipython>=7.31.1,<8" "ipython"
  '';

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Jupyter kernels for Spyder's console";
    homepage = "https://docs.spyder-ide.org/current/ipythonconsole.html";
    downloadPage = "https://github.com/spyder-ide/spyder-kernels/releases";
    changelog = "https://github.com/spyder-ide/spyder-kernels/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
