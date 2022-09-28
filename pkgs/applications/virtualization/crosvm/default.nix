{ stdenv, lib, rustPlatform, fetchgit
, minijail-tools, pkg-config, protobuf, wayland-scanner
, libcap, libdrm, libepoxy, minijail, virglrenderer, wayland, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "crosvm";
  version = "106.2";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "d58d398581724e81ce57a8dfaeef62c175c06552";
    sha256 = "huZELmB1oH5RyasmpEXIcJ/mB4fi6fMofj1N01COeI8=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  patches = [
    ./default-seccomp-policy-dir.diff
  ];

  cargoSha256 = "18mj0zc6yfwyrw6v1vl089dhh04kv2pzb99bygnn8nymdlx4fjqa";

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
