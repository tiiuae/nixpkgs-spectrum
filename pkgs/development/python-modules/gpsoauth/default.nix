{ lib
, buildPythonPackage
, fetchPypi
, pycryptodomex
, pythonOlder
, requests
}:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "gpsoauth";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wxLyvrNwT3QQHGLCxaIFdRG7OJpECMpynE+lgAGtFk0=";
  };

  propagatedBuildInputs = [ pycryptodomex requests ];

  # upstream tests are not very comprehensive
  doCheck = false;

  pythonImportsCheck = [ "gpsoauth" ];

  meta = with lib; {
    description = "Library for Google Play Services OAuth";
    homepage = "https://github.com/simon-weber/gpsoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
  };
}
