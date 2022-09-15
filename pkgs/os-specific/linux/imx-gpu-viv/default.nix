{ stdenv
, fetchurl
, lib
}:

stdenv.mkDerivation rec {
  pname = "imx-gpu-viv";
  version = "6.4.3.p4.2";

  FSL_MIRROR = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/";

  # meta-freescale/conf/layer.conf
  # FSL_MIRROR = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/";
  # SRC_URI = "${FSL_MIRROR}/${BPN}-${PV}.bin;fsl-eula=true"
  src = fetchurl {
    url = "${FSL_MIRROR}/${pname}-${version}-aarch64.bin";
    sha256 = "sha256-UpIcC1lSnxWYCE6ZHtoYYxAHVPKKd0S6lYFY3/gHSzs=";
    name = "${pname}-${version}-aarch64.bin";
  };

  # meta-freescale/classes/fsl-eula-unpack.bbclass
  # cmd = "sh %s --auto-accept --force" % (url.localpath)
  dontBuild = true;
  unpackPhase = ''
    sh ${src} --auto-accept --force
  '';

  # meta-imx/meta-bsp/recipes-graphics/imx-g2d/imx-dpu-g2d_2.1.0.bb
  # cp -r -d --no-preserve=ownership ${S}/g2d/* ${D}
  installPhase = ''
    mkdir -p $out
    cp -rd --no-preserve=ownership $pname-$version-aarch64/gpu-core/usr/* $out
  '';

  # outputs = [ "out" "dev" "drivers" ];
  outputs = [ "out" "dev" ];
    
  meta = with lib; {
    description = "GPU driver for i.MX";
    homepage = "http://www.nxp.com/";
    license = licenses.unfree;
    # maintainers = with maintainers;
    platforms = platforms.linux;
  };
}
