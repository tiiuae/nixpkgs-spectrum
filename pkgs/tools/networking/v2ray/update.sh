#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

version_nix=./default.nix
deps_nix=./deps.nix
nixpkgs=../../../..

old_core_rev=$(sed -En 's/.*\bversion = "(.*?)".*/\1/p' "$version_nix")
echo "Current version:" >&2
echo "core: $old_core_rev" >&2

function fetch_latest_rev {
    curl "https://api.github.com/repos/v2fly/$1/releases" |
        jq '.[0].tag_name' --raw-output
}

core_rev=$(fetch_latest_rev 'v2ray-core')
core_rev=${core_rev:1}
echo "Latest version:" >&2
echo "core: $core_rev" >&2

if [[ $core_rev != $old_core_rev ]]; then
    echo "Prefetching core..." >&2
    { read hash; read store_path; } < <(
        nix-prefetch-url --unpack --print-path "https://github.com/v2fly/v2ray-core/archive/v$core_rev.zip"
    )

    sed --in-place \
        -e "s/\bversion = \".*\"/version = \"$core_rev\"/" \
        -e "s/\bsha256 = \".*\"/sha256 = \"$hash\"/" \
        -e "s/\bvendorSha256 = \".*\"/vendorSha256 = \"0000000000000000000000000000000000000000000000000000\"/" \
        "$version_nix"
fi

echo "Prebuilding..." >&2
set +o pipefail
vendorSha256=$(
    nix-build "$nixpkgs" -A v2ray --no-out-link 2>&1 |
    tee /dev/stderr |
    sed -nE 's/.*got:\s*(sha256\S+)$/\1/p'
)
[[ "$vendorSha256" ]]
sed --in-place \
    -e "s#vendorSha256 = \".*\"#vendorSha256 = \"$vendorSha256\"#" \
    "$version_nix"

echo "vendorSha256 updated" >&2
