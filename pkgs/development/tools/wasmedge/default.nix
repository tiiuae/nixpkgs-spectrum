{ lib
, fetchFromGitHub
, llvmPackages
, boost
, cmake
, gtest
, spdlog
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "wasmedge";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
    rev = version;
    sha256 = "sha256-4w9+3hp1GVLx2dOTDXlUOH6FgK1jvkt12wXs4/S9UlI=";
  };

  buildInputs = [
    boost
    spdlog
    llvmPackages.llvm
  ];

  nativeBuildInputs = [ cmake llvmPackages.lld ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DWASMEDGE_BUILD_TESTS=OFF" # Tests are downloaded using git
  ];

  meta = with lib; {
    homepage = "https://wasmedge.org/";
    license = with licenses; [ asl20 ];
    description = "A lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications";
    maintainers = with maintainers; [ dit7ya ];
  };
}
