{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, azure-core
, msrestazure
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-eventgrid";
  version = "4.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-8jEtTQTUJLSa2iuA/Sgirgcm8kbwWOT11O1n46CLouw=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    msrestazure
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.eventgrid"
  ];

  meta = with lib; {
    description = "A fully-managed intelligent event routing service that allows for uniform event consumption using a publish-subscribe model";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
