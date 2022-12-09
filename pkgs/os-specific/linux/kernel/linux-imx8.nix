{ lib, stdenv, buildPackages, fetchgit, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.15.32";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  defconfig = "imx_v8_defconfig";

  autoModules = false;

  extraConfig = ''
    CRYPTO_TLS m
    TLS y
    MD_RAID0 m
    MD_RAID1 m
    MD_RAID10 m
    MD_RAID456 m
    DM_VERITY m
    LOGO y
    FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER n
    FB_EFI n
  '';

  src = fetchgit {
    url = "https://source.codeaurora.org/external/imx/linux-imx";
    rev = "fa6c3168595c02bd9d5366fcc28c9e7304947a3d"; # lf-5.15.y
    sha256 = "sha256-Z24CpePoP28tBumTGc8ZUm/5WghuhtO2jvPOKtNaYGA=";
  };
} // (args.argsOverride or { }))
