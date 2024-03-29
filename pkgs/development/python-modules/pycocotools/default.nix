{ lib
, buildPythonPackage
, fetchPypi
, cython
, matplotlib
}:

buildPythonPackage rec {
  pname = "pycocotools";
  version = "2.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QdH7Bi31urXrw+kpcUVaoIlHnnzRBVMnjKVGKLncm/U=";
  };

  propagatedBuildInputs = [
    cython
    matplotlib
  ];

  pythonImportsCheck = [
    "pycocotools.coco"
    "pycocotools.cocoeval"
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Official APIs for the MS-COCO dataset";
    homepage = "https://github.com/cocodataset/cocoapi/tree/master/PythonAPI";
    license = licenses.bsd2;
    maintainers = with maintainers; [ piegames ];
  };
}
