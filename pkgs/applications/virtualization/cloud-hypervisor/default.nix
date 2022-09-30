{ lib, stdenv, fetchCrate, fetchFromGitHub, fetchpatch, rustPlatform
, pkg-config, dtc, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "26.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-choTT20TVp42nN/vS6xCDA7Mbf1ZuAE1tFQZn49g9ak=";
  };

  vhost = fetchCrate {
    pname = "vhost";
    version = "0.4.0";
    sha256 = "sha256-72tvycgdTI3pK1EpGoBEI0WajX7SYZvTI0lbU8ybdsc=";
  };

  vm-virtio = fetchFromGitHub {
    owner = "rust-vmm";
    repo = "vm-virtio";
    rev = "7e203db6ed044217acd80dec5967c15d979491f8";
    sha256 = "sha256-QLukQCPeWpletbKqhIruvevLMEepnQ4fKWVH42H7QM8=";
  };

  postUnpack = ''
    unpackFile ${vhost}
    mv vhost-* vhost

    unpackFile ${vm-virtio}/crates/virtio-bindings

    chmod -R +w vhost virtio-bindings
  '';

  cargoPatches = [
    ./0001-build-use-local-vhost.patch
    ./0002-build-use-local-virtio-bindings.patch
    ./0003-virtio-devices-add-a-vhost-user-gpu-device.patch
    ./0004-virtio-devices-try-mapping-shared-memory-as-RO-if-RW.patch
  ];

  vhostPatches = [
    ./vhost-vhost_user-add-shared-memory-region-support.patch
  ];

  virtioBindingsPatches = [
    # https://github.com/rust-vmm/vm-virtio/pull/194
    ./0001-virtio-bindings-regenerate-with-bindgen-0.60.1.patch
    ./0002-virtio-bindings-remove-workaround-for-old-bindgen.patch
    ./0003-virtio-bindings-regenerate-with-Glibc-2.36.patch
    ./0004-virtio-bindings-regenerate-with-Linux-5.19.patch

    ./0005-virtio-bindings-add-virtio-gpu-bindings.patch
  ];

  postPatch = ''
    pushd ../vhost
    for patch in $vhostPatches; do
        echo applying patch $patch
        patch -p1 < $patch
    done
    popd

    pushd ../virtio-bindings
    for patch in $virtioBindingsPatches; do
        echo applying patch $patch
        patch -p3 < $patch
    done
    popd
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isAarch64 dtc;

  cargoSha256 = "164vr9xxrlpllac5db69ggasczq5vqb9zv60dkwbqabn8qm5cr1x";

  OPENSSL_NO_VENDOR = true;

  # Integration tests require root.
  cargoTestFlags = [ "--bins" ];

  meta = with lib; {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${version}";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ offline qyliss ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
