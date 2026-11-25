#!/bin/sh
# Points the formula and the cask at a release of lifthrasiir/aqueous (the latest by default):
#
#   ./update.sh [TAG]
#
# The SHA-256s are the release assets' digests as GitHub gives them (gh needed). Each asset is
# downloaded and checked against its digest and against its attestation of build provenance: made
# by lifthrasiir/aqueous's release.yml, for the tag, on a runner hosted by GitHub. Nothing is
# changed unless all of them hold.
set -eu
cd "$(dirname "$0")"
repo=lifthrasiir/aqueous
tag=${1:-$(gh release view -R "$repo" --json tagName -q .tagName)}
# (the tag goes into perl's code below and into the URLs: vMAJOR.MINOR.PATCH[-PRERELEASE] alone,
# as lifthrasiir/aqueous's scripts/release-env.sh takes it)
printf '%s\n' "$tag" | grep -Eqx 'v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.]+)?' ||
    { echo "$0: not a tag of a release: $tag" >&2; exit 1; }
version=${tag#v}
# (the assets' names, as release-env.sh's STEM: the date alone of v0.0.YYYYMMDD, else the version)
if printf '%s\n' "$tag" | grep -Eqx 'v0\.0\.[0-9]{8}'; then stem=${tag#v0.0.}; else stem=$version; fi
if grep -qx "  version \"$version\"" Formula/aqr.rb && grep -qx "  version \"$version\"" Casks/aqueous.rb; then
    echo "Already at $tag."
    exit 0
fi
digests=$(gh release view "$tag" -R "$repo" --json assets -q '.assets[] | "\(.name) \(.digest)"')
sha() {
    d=$(printf '%s\n' "$digests" | awk -v n="aqr-$stem-$1" '$1 == n { sub(/^sha256:/, "", $2); print $2 }')
    printf '%s\n' "$d" | grep -Eqx '[0-9a-f]{64}' || { echo "$0: no asset aqr-$stem-$1 in $tag" >&2; exit 1; }
    echo "$d"
}
mac=$(sha mac.zip) x86=$(sha linux-x86_64.tar.xz) arm=$(sha linux-aarch64.tar.xz)
dl=$(mktemp -d)
trap 'rm -rf "$dl"' EXIT
for a in "mac.zip $mac" "linux-x86_64.tar.xz $x86" "linux-aarch64.tar.xz $arm"; do
    f=aqr-$stem-${a% *}
    gh release download "$tag" -R "$repo" -p "$f" -D "$dl"
    echo "${a#* }  $dl/$f" | shasum -a 256 -c -
    gh attestation verify "$dl/$f" -R "$repo" \
        --signer-workflow "$repo/.github/workflows/release.yml" \
        --source-ref "refs/tags/$tag" --deny-self-hosted-runners
done
# (each url line followed by its sha256 line)
perl -0pi -e '
    s/^([ \t]*version ")[^"]*"/${1}'"$version"'"/m;
    s{/download/[^/"]+/aqr-[^"]*-(mac\.zip|linux-x86_64\.tar\.xz|linux-aarch64\.tar\.xz)"}{/download/'"$tag"'/aqr-'"$stem"'-$1"}g;
    s/(mac\.zip"\n[ \t]*sha256 ")\w+/${1}'"$mac"'/;
    s/(linux-x86_64\.tar\.xz"\n[ \t]*sha256 ")\w+/${1}'"$x86"'/;
    s/(linux-aarch64\.tar\.xz"\n[ \t]*sha256 ")\w+/${1}'"$arm"'/;
' Formula/aqr.rb
perl -0pi -e '
    s/^([ \t]*version ")[^"]*"/${1}'"$version"'"/m;
    s{/download/[^/"]+/aqr-[^"]*-(mac\.zip|linux-x86_64\.tar\.xz|linux-aarch64\.tar\.xz)"}{/download/'"$tag"'/aqr-'"$stem"'-$1"}g;
    s/^([ \t]*sha256 ")\w+/${1}'"$mac"'/m;
' Casks/aqueous.rb
git --no-pager diff --stat
