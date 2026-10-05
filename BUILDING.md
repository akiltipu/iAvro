# Building and checking iAvro

Use native arm64 macOS and full Xcode. No CocoaPods, Homebrew packages, downloaded
binary libraries or dependency replacements are required. VS Code can open this
folder; run the following commands in its integrated terminal. There is no
workspace dependency setup: the project is `AvroKeyboard.xcodeproj`, with one
target and scheme named `Avro Keyboard` and Debug/Release configurations.

## Verified local toolchain

Recorded 2026-10-05:

| Item | Value |
| --- | --- |
| Host | arm64, macOS 27.0.1 (26A434) |
| Xcode | 27.0 (27A266a) |
| Selected developer directory | `/Applications/Xcode.app/Contents/Developer` |
| macOS SDK | 27.0 (26A425) |
| Apple clang | 21.0.0 (`clang-2100.3.34.2`) |

`scripts/check.sh` records these values again on each run, including any
`DEVELOPER_DIR` override. Selecting a different Xcode can change the result.

## Reproducible checks

```sh
./scripts/check.sh
```

Or choose an **empty directory outside the checkout** and configuration:

```sh
CHECK_OUTPUT=$(mktemp -d "${TMPDIR:-/tmp}/iavro-debug.XXXXXX")
./scripts/check.sh "$CHECK_OUTPUT" Debug

RELEASE_OUTPUT=$(mktemp -d "${TMPDIR:-/tmp}/iavro-release.XXXXXX")
./scripts/check.sh "$RELEASE_OUTPUT" Release
```

Release here means Xcode's optimization configuration; it does not mean a
distribution-ready signed release. The script rejects non-arm64 hosts and
nonempty output directories. It does not change the installation or user data.

It runs `xcodebuild -list` and `-showBuildSettings` before this build command
(`CHECK_OUTPUT` refers to the chosen empty output directory):

```sh
/usr/bin/xcodebuild -project AvroKeyboard.xcodeproj \
  -scheme 'Avro Keyboard' -configuration Debug \
  -destination 'generic/platform=macOS' \
  -derivedDataPath "$CHECK_OUTPUT/DerivedData" ARCHS=arm64 \
  -resultBundlePath "$CHECK_OUTPUT/build.xcresult" build
```

The script writes each exact command, full log and original exit code as
`NAME.command`, `NAME.log` and `NAME.exit`. In particular, `build.exit` is
xcodebuild's status, unaffected by a `tee` pipeline. It returns that status if
the build fails. The app is under
`DerivedData/Build/Products/Debug/Avro Keyboard.app` (or `Release`).

Further checks verify the strict code signature, read the actual executable
name from `CFBundleExecutable`, inspect every bundled Mach-O using `file`,
`lipo` and `otool`, and load each direct system dependency in a separate native
probe to inspect its Mach-O header. This handles libraries in the dyld shared
cache. The current bundle has one arm64 executable, nine direct system
dependencies and no runpaths. Unexpected non-system paths or `LC_RPATH` cause
failure until separately reviewed. See [test scope](tests/README.md).

Builds currently succeed with ordinary local ad-hoc signing; no signing bypass
was needed. If signing fails elsewhere, retain that failure before trying a
separate explicitly labeled compile-only build with signing disabled. Such a
build proves neither runtime viability nor distribution readiness.

## Deployment target and dependencies

The existing project does not explicitly set `MACOSX_DEPLOYMENT_TARGET`. The
verified Xcode 27 build inherits 27.0 from its SDK and generates
`LSMinimumSystemVersion=27.0`. This is observed inheritance, not a newly chosen
support floor. No deployment setting was raised. Choosing an explicit lower
floor requires separate SDK/API checks and runtime testing on that OS.

| Component | Source/linkage | arm64 evidence |
| --- | --- | --- |
| App/controller/candidate/preferences UI | In-tree Objective-C, Cocoa and InputMethodKit | Compiled natively; local Debug IMK tests |
| AvroParser, RegexParser, AutoCorrect, Database, Suggestion, CacheManager | In-tree Objective-C and original bundled data | Native build; focused parser/resource tests |
| RegexKitLite | In-tree C/Objective-C, system `libicucore` | Native build and real regex match |
| FMDB | In-tree Objective-C, system `libsqlite3` | Native build, dictionary integrity and lookup |
| NSString+Levenshtein | In-tree Objective-C | Native build; no separate behavior coverage |
| Cocoa, Foundation, InputMethodKit, AppKit, CoreFoundation, ICU, SQLite, libobjc, libSystem | Apple system frameworks/libraries | All nine direct loaded headers are ARM64 on tested host |

No bundled static library, external framework, vendored Intel binary or
CocoaPods project was found. The dependency probe establishes the loaded
architecture on its host, not compatibility with every macOS version.

## CI

`.github/workflows/arm64.yml` runs the same Debug checks on PRs and pushes.
Official documentation checked on 2026-10-05 identifies `macos-26` as ARM64
and lists Xcode 26.6 at `/Applications/Xcode_26.6.app`; the workflow selects
that toolchain explicitly. The inventory lists macOS SDK 26.5 for it.
[Runner labels](https://docs.github.com/en/actions/reference/runners/github-hosted-runners)
and [installed toolchains](https://github.com/actions/runner-images/blob/main/images/macos/macos-26-arm64-Readme.md)
can change, so inspect the environment log for each run.

The workflow pins checkout and upload-artifact v7.0.1 to verified commit SHAs,
has only `contents: read`, disables persisted checkout credentials and retains
diagnostic logs for seven days. It uses no signing secrets or
`pull_request_target` and uploads no app bundle. Remote CI is **NOT RUN** until
the changes are committed/pushed with the owner's authorization. Its isolated
checks do not test InputMethodKit registration or interactive typing.
