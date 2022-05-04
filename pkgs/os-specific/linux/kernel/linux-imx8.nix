{ lib, stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.10.109";
  nxp_ref = "5.10-2.1.x-imx";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  defconfig = "imx_v8_defconfig";

  extraConfig = ''
    SECURE_KEYS n
    FB n
    FB_MXC n
    FB_MXS n
    MFD_MAX17135 n
    REGULATOR_ARM_SCMI n
    REGULATOR_PF1550_RPMSG n
    MXC_PXP y
    SND_IMX_SOC n
    VIDEO_MXC_CAPTURE n
    SENSORS_MAG3110 n
    SENSORS_MAX17135 n
    CRYPTO_TLS n
    STAGING n
  '';

  src = fetchGit {
    url = "https://github.com/Freescale/linux-fslc.git";
    ref = nxp_ref;
  };
} // (args.argsOverride or { }))
