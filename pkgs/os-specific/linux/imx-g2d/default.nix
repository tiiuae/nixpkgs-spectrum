{ stdenv
, fetchurl
, lib
}:

stdenv.mkDerivation rec {
  pname = "imx-dpu-g2d";
  version = "2.1.0";

  FSL_MIRROR = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/";

  # meta-freescale/conf/layer.conf
  # FSL_MIRROR = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/";
  # SRC_URI = "${FSL_MIRROR}/${BPN}-${PV}.bin;fsl-eula=true"
  src = fetchurl {
    url = "${FSL_MIRROR}/${pname}-${version}.bin";
    sha256 = "sha256-ZazHNF3K85U21g7kUWrXMcQDeQ7QXWGoGGATklVKZiA=!";
    name = "${pname}-${version}.bin";
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
    # cp -rd --no-preserve=ownership $pname-$version/g2d/* $out
    cp -rd --no-preserve=ownership $pname-$version/g2d/usr/* $out
  '';

  # outputs = [ "out" "dev" "drivers" ];
  outputs = [ "out" "dev" ];
  
  meta = with lib; {
    description = "GPU G2D library and apps for i.MX with 2D GPU and DPU";
    homepage = "http://www.nxp.com/";
    license = licenses.unfree;
    # maintainers = with maintainers;
    platforms = platforms.linux;
  };
}
