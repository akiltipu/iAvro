#!/bin/bash
# Create a local experimental package; never install or publish it.
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
VERSION=${2:-1.0.0-community.1}
case "$VERSION" in ''|*[!a-zA-Z0-9.-]*) echo 'Invalid package version' >&2; exit 2 ;; esac
if [[ -n $(git -C "$ROOT" status --porcelain --untracked-files=all) ]]; then
    echo 'Package from a clean checkout, including no untracked files.' >&2
    exit 2
fi
OUT=${1:-$(mktemp -d "${TMPDIR:-/tmp}/iavro-package.XXXXXX")}
mkdir -p "$OUT"
OUT=$(cd "$OUT" && pwd -P)
case "$OUT/" in "$ROOT/"*) echo 'Output must be outside the checkout.' >&2; exit 2 ;; esac
[[ -z $(ls -A "$OUT") ]] || { echo 'Output must be empty.' >&2; exit 2; }
"$ROOT/scripts/check.sh" "$OUT/check" Release
APP="$OUT/check/DerivedData/Build/Products/Release/Avro Keyboard.app"
PLIST="$APP/Contents/Info.plist"
APP_VERSION=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$PLIST")
[[ "$VERSION" == "$APP_VERSION"-community.* ]] || { echo 'Package and app versions disagree.' >&2; exit 1; }
/usr/bin/codesign -d --entitlements - --xml "$APP" > "$OUT/entitlements.plist" 2> "$OUT/entitlements.log"
if grep -q 'com.apple.security.get-task-allow' "$OUT/entitlements.plist"; then
    echo 'Refusing to package a debugging entitlement.' >&2; exit 1
fi
/usr/bin/codesign -d --verbose=4 "$APP" > "$OUT/signature.log" 2>&1
grep -q 'flags=.*runtime' "$OUT/signature.log"

LABEL="iAvro-$VERSION"
STAGE="$OUT/$LABEL-arm64"
mkdir "$STAGE"
/usr/bin/ditto "$APP" "$STAGE/Avro Keyboard.app"
for document in INSTALL.md NOTICES.md MODIFICATIONS.md PROVENANCE.md TESTING.md; do
    cp "$ROOT/$document" "$STAGE/$document"
done
/usr/bin/ditto "$ROOT/LICENSES" "$STAGE/LICENSES"
COMMIT=$(git -C "$ROOT" rev-parse HEAD)
cat > "$STAGE/SOURCE.txt" <<EOF
Unofficial community iAvro $VERSION
Source commit: $COMMIT
Repository: https://github.com/akiltipu/iAvro
Corresponding source: https://github.com/akiltipu/iAvro/releases/download/v$VERSION/$LABEL-source.zip
See NOTICES.md, MODIFICATIONS.md and LICENSES/ for terms and changes.
Architecture: arm64 only
Signing: ad-hoc, hardened runtime; not Developer ID signed or notarized
EOF

git -C "$ROOT" archive --format=zip --prefix="$LABEL-source/" -o "$OUT/$LABEL-source.zip" HEAD
/usr/bin/ditto -c -k --sequesterRsrc --keepParent "$STAGE" "$OUT/$LABEL-arm64.zip"
/usr/bin/ditto -x -k "$OUT/$LABEL-arm64.zip" "$OUT/roundtrip"
RESTORED="$OUT/roundtrip/$LABEL-arm64/Avro Keyboard.app"
diff -rq "$APP" "$RESTORED" > "$OUT/roundtrip-diff.log"
/usr/bin/codesign --verify --strict --verbose=2 "$RESTORED" > "$OUT/roundtrip-signature.log" 2>&1
EXECUTABLE=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$RESTORED/Contents/Info.plist")
[[ $(/usr/bin/lipo -archs "$RESTORED/Contents/MacOS/$EXECUTABLE") == arm64 ]]
(cd "$OUT" && /usr/bin/shasum -a 256 "$LABEL-arm64.zip" "$LABEL-source.zip" > SHA256SUMS)
printf 'Package verified: %s\nSource: %s\nChecksums: %s\n' \
    "$OUT/$LABEL-arm64.zip" "$OUT/$LABEL-source.zip" "$OUT/SHA256SUMS"
