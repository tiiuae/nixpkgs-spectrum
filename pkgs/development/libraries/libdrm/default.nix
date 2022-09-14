{ stdenv, lib, fetchgit, pkg-config, meson, ninja, docutils
, libpthreadstubs, libpciaccess
, withValgrind ? valgrind-light.meta.available, valgrind-light
}:

stdenv.mkDerivation rec {
  pname = "libdrm";
  version = "2.4.109";


  # meta-imx/meta-bsp/recipes-graphics/drm/libdrm_2.4.109.imx.bb
  src = fetchgit {
    url = "https://source.codeaurora.org/external/imx/libdrm-imx.git";
    rev = "93c9a82bdf31ea055d45cb54ce57cd42e22c90ae";
    sha256 = "sha256-sXy5ghJLC9wI3dypLdQ3/Zoptiyv+ghjbmnQfiBaasY=";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ pkg-config meson ninja docutils ];
  buildInputs = [ libpthreadstubs libpciaccess ]
    ++ lib.optional withValgrind valgrind-light;

  patches = [ ./cross-build-nm-path.patch ];

  mesonFlags = [
    "-Dnm-path=${stdenv.cc.targetPrefix}nm"
    "-Dinstall-test-programs=true"
    "-Domap=true"
  ] ++ lib.optionals (stdenv.isAarch32 || stdenv.isAarch64) [
    "-Dtegra=true"
    "-Detnaviv=true"
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/mesa/drm";
    downloadPage = "https://dri.freedesktop.org/libdrm/";
    description = "Direct Rendering Manager library and headers";
    longDescription = ''
      A userspace library for accessing the DRM (Direct Rendering Manager) on
      Linux, BSD and other operating systems that support the ioctl interface.
      The library provides wrapper functions for the ioctls to avoid exposing
      the kernel interface directly, and for chipsets with drm memory manager,
      support for tracking relocations and buffers.
      New functionality in the kernel DRM drivers typically requires a new
      libdrm, but a new libdrm will always work with an older kernel.

      libdrm is a low-level library, typically used by graphics drivers such as
      the Mesa drivers, the X drivers, libva and similar projects.
    '';
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
