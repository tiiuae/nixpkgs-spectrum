{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0csh307zfz666kkk5idrw3crj1x8q8vsqgwqil0r1n1hs4p7ica7";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pyyaml"' ""
  '';

  doCheck = false; # requires files from uap-core

  pythonImportsCheck = [ "ua_parser" ];

  meta = with lib; {
    description = "A python implementation of the UA Parser";
    homepage = "https://github.com/ua-parser/uap-python";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
