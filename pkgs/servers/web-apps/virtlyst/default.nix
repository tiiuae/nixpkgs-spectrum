{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, autoPatchelfHook
, qtbase, libvirt, cutelyst, grantlee }:

stdenv.mkDerivation rec {
  pname = "virtlyst";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "cutelyst";
    repo = "Virtlyst";
    rev = "v${version}";
    sha256 = "1vgjai34hqppkpl0ryxkyhpm9dsx1chs3bii3wc3h40hl80n6dgy";
  };

  nativeBuildInputs = [ cmake pkg-config autoPatchelfHook ];
  buildInputs = [ qtbase libvirt cutelyst grantlee ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp src/libVirtlyst${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib
    cp -r ../root $out

    runHook postInstall
  '';

  patches = [ ./add-admin-password-env.patch ];

  meta = with lib; {
    description = "Web interface to manage virtual machines with libvirt";
    homepage = "https://github.com/cutelyst/Virtlyst";
    license = licenses.agpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
