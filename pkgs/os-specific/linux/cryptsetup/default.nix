{ lib, stdenv, fetchurl, fetchpatch, pkg-config
, lvm2, json_c, openssl, libuuid, popt
# Programs enabled by default upstream are implicitly enabled unless
# manually set to false.
, programs ? { cryptsetup-reencrypt = true; }
}:

stdenv.mkDerivation rec {
  pname = "cryptsetup";
  version = "2.4.3";

  outputs = [ "bin" "out" "dev" "man" ];
  separateDebugInfo = true;

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v2.4/${pname}-${version}.tar.xz";
    sha256 = "sha256-/A35RRiBciZOxb8dC9oIJk+tyKP4VtR+upHzH+NUtQc=";
  };

  patches = [
    # Disable 4 test cases that fail in a sandbox
    ./disable-failing-tests.patch

    # If the cryptsetup program is disabled, skip tests that require it.
    # https://gitlab.com/cryptsetup/cryptsetup/-/merge_requests/267
    (fetchpatch {
      url = "https://gitlab.com/cryptsetup/cryptsetup/-/commit/42e7e4144ce4d0923b3dc4d860fc3b67ce29dbb9.patch";
      sha256 = "19s0pw5055skjsanf90akppjzs7lbyl7ay09lsn8v65msw7jqr2s";
    })
  ];

  postPatch = ''
    patchShebangs tests

    # O_DIRECT is filesystem dependent and fails in a sandbox (on tmpfs)
    # and on several filesystem types (btrfs, zfs) without sandboxing.
    # Remove it, see discussion in #46151
    substituteInPlace tests/unit-utils-io.c --replace "| O_DIRECT" ""
  '';

  NIX_LDFLAGS = lib.optionalString (stdenv.cc.isGNU && !stdenv.hostPlatform.isStatic) "-lgcc_s";

  configureFlags = [
    "--enable-cryptsetup-reencrypt"
    "--with-crypto_backend=openssl"
    "--disable-ssh-token"
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "--disable-external-tokens"
    # We have to override this even though we're removing token
    # support, because the path still gets included in the binary even
    # though it isn't used.
    "--with-luks2-external-tokens-path=/"
  ] ++ (with lib; mapAttrsToList (flip enableFeature)) programs;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lvm2 json_c openssl libuuid popt ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/cryptsetup/cryptsetup/";
    description = "LUKS for dm-crypt";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
