{ lib, stdenv, fetchFromGitHub, pkg-config, pidgin, libwebp, libgcrypt, gettext } :

stdenv.mkDerivation rec {
  pname = "telegram-purple";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "majn";
    repo = "telegram-purple";
    rev = "v${version}";
    sha256 = "sha256-14VzCMvzAEmye0N98r+P+ub5CeA9vu8c/xqefuWVI10=";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=cast-function-type";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pidgin libwebp libgcrypt gettext ];

  preConfigure = ''
    sed -i "s|/etc/telegram-purple/server.tglpub|$out/lib/purple-2/server.tglpub|g" telegram-purple.c
    echo "#define GIT_COMMIT \"${builtins.substring 0 10 src.rev}\"" > commit.h
  '';

  installPhase = ''
    mkdir -p $out/lib/purple-2/
    cp bin/*.so $out/lib/purple-2/ #*/
    cp tg-server.tglpub $out/lib/purple-2/server.tglpub
    mkdir -p $out/pixmaps/pidgin/protocols/{16,22,48}
    cp imgs/telegram16.png $out/pixmaps/pidgin/protocols/16
    cp imgs/telegram22.png $out/pixmaps/pidgin/protocols/22
    cp imgs/telegram48.png $out/pixmaps/pidgin/protocols/48
  '';

  meta = with lib; {
    homepage = "https://github.com/majn/telegram-purple";
    description = "Telegram for Pidgin / libpurple";
    license = licenses.gpl2;
    maintainers = [ maintainers.jagajaga ];
    platforms = platforms.linux;
  };
}
