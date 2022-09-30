{ stdenv, lib, rustPlatform, fetchgit
, minijail-tools, pkg-config, protobuf, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "106.2-security-context";

  src = fetchgit {
    url = "https://puck.moe/git/crosvm";
    rev = "eb1a080dd8432ea7ad400816388d67a5d64081e4";
    sha256 = "sha256-iExgWO1/PBCWvzV+5Z6UrKxOsHaFED9GcGQGc4rVJw0=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  patches = [
    ./default-seccomp-policy-dir.diff

    ./devices-properly-consider-shm-buuffers-when-setting-.patch
    ./devices-vhost_user-remove-spurious-check.patch
    ./devices-vhost_user-loosen-expected-message-order.patch
  ];

  cargoSha256 = "1fasy7l8ia53739wzz4cgbphn7h4gv1rfz0syqbl4kfl6hy0p1vb";

  nativeBuildInputs = [ minijail-tools pkg-config protobuf wayland-scanner ];

  buildInputs = [
    libcap libdrm libepoxy minijail virglrenderer wayland wayland-protocols
  ];

  arch = stdenv.hostPlatform.parsed.cpu.name;

  postPatch = ''
    sed -i "s|/usr/share/policy/crosvm/|$PWD/seccomp/$arch/|g" \
        seccomp/$arch/*.policy
  '';

  preBuild = ''
    export DEFAULT_SECCOMP_POLICY_DIR=$out/share/policy

    for policy in seccomp/$arch/*.policy; do
        compile_seccomp_policy \
            --default-action trap $policy ''${policy%.policy}.bpf
    done

    substituteInPlace seccomp/$arch/*.policy \
      --replace "@include $(pwd)/seccomp/$arch/" "@include $out/share/policy/"
  '';

  buildFeatures = [ "default" "virgl_renderer" "virgl_renderer_next" ];

  postInstall = ''
    mkdir -p $out/share/policy/
    cp -v seccomp/$arch/*.{policy,bpf} $out/share/policy/
  '';

  passthru.updateScript = ./update.py;

  meta = with lib; {
    description = "A secure virtual machine monitor for KVM";
    homepage = "https://chromium.googlesource.com/crosvm/crosvm/";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.bsd3;
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
