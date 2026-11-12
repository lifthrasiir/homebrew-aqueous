#!/bin/sh
# Points the formula and the cask at a release of lifthrasiir/aqueous (the latest by default):
#
#   ./update.sh [TAG]
#
# The SHA-256s are the release assets' digests as GitHub gives them (gh needed).
set -eu
cd "$(dirname "$0")"
repo=lifthrasiir/aqueous
tag=${1:-$(gh release view -R "$repo" --json tagName -q .tagName)}
version=${tag#v}
stem=${tag#v0.0.}
digests=$(gh release view "$tag" -R "$repo" --json assets -q '.assets[] | "\(.name) \(.digest)"')
sha() {
    d=$(printf '%s\n' "$digests" | awk -v n="aqr-$stem-$1" '$1 == n { sub(/^sha256:/, "", $2); print $2 }')
    [ -n "$d" ] || { echo "$0: no asset aqr-$stem-$1 in $tag" >&2; exit 1; }
    echo "$d"
}
mac=$(sha mac.zip) x86=$(sha linux-x86_64.tar.xz) arm=$(sha linux-aarch64.tar.xz)
# (each url line followed by its sha256 line)
perl -0pi -e '
    s/^([ \t]*version ")[^"]*"/${1}'"$version"'"/m;
    s{v0\.0\.\d+/aqr-\d+-}{'"$tag"'/aqr-'"$stem"'-}g;
    s/(mac\.zip"\n[ \t]*sha256 ")\w+/${1}'"$mac"'/;
    s/(linux-x86_64\.tar\.xz"\n[ \t]*sha256 ")\w+/${1}'"$x86"'/;
    s/(linux-aarch64\.tar\.xz"\n[ \t]*sha256 ")\w+/${1}'"$arm"'/;
' Formula/aqr.rb
perl -0pi -e '
    s/^([ \t]*version ")[^"]*"/${1}'"$version"'"/m;
    s/^([ \t]*sha256 ")\w+/${1}'"$mac"'/m;
' Casks/aqueous.rb
git --no-pager diff --stat
