{ lib
, buildPythonPackage
, cheroot
, colorama
, fetchFromGitHub
, fsspec
, httpx
, pytestCheckHook
, python-dateutil
, pythonOlder
, setuptools-scm
, wsgidav
}:

buildPythonPackage rec {
  pname = "webdav4";
  version = "0.9.7";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "skshetry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7v4dcwbTCGiEMkAQHtH9+zQj745dI0QqoEqdxRYRuO4=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    httpx
    python-dateutil
  ];

  checkInputs = [
    cheroot
    colorama
    pytestCheckHook
    wsgidav
  ] ++ passthru.optional-dependencies.fsspec;

  passthru.optional-dependencies = {
    fsspec = [
      fsspec
    ];
    http2 = [
      httpx.optional-dependencies.http2
    ];
    all = [
      fsspec
      httpx.optional-dependencies.http2
    ];
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  pythonImportsCheck = [
    "webdav4"
  ];

  disabledTests = [
    # ValueError: Invalid dir_browser htdocs_path
    "test_retry_reconnect_on_failure"
    "test_open"
    "test_open_binary"
    "test_close_connection_if_nothing_is_read"
  ];

  disabledTestPaths = [
    # Tests requires network access
    "tests/test_client.py"
    "tests/test_fsspec.py"
  ];

  meta = with lib; {
    description = "Library for interacting with WebDAV";
    homepage = "https://skshetry.github.io/webdav4/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
