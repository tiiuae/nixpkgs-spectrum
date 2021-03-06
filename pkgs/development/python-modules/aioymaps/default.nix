{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioymaps";
  version = "1.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZWolVsh6MSEA3h62ERaCLSVAr+vl53yysPjulMtW4QI=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioymaps" ];

  meta = with lib; {
    description = "Python package fetch data from Yandex maps";
    homepage = "https://github.com/devbis/aioymaps";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
