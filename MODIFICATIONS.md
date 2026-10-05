# Community modifications

Base: OmicronLab iAvro commit `107a73283ac34a33faf7f6799c2e9dbfa97e6643`.
Community maintainer: AkilTipu. This is not an official OmicronLab release.

## 2026-10-04 to 2026-10-06

- `AvroKeyboard.xcodeproj/project.pbxproj`: select arm64 for Debug/Release;
  later enable hardened runtime and suppress injected debugging entitlements
  for Release. Preserve the existing deployment-target behavior.
- `AvroKeyboardController.h/.m`: obtain the live InputMethodKit client at
  insertion and use a valid remembered/first candidate when the panel has no
  explicit selection. Avoid attempting an empty-list commit.
- `Info.plist`: replace the placeholder bundle name; add version 1.0.0 and
  community build 10001 for the first experimental prerelease.
- `NSString+Levenshtein.h/.m`: replace the former third-party implementation
  with an independently written, one-row unit-cost distance calculation under
  MPL 1.1. The public method, UTF-16 comparisons and -1 empty-input behavior
  are retained. Allocation failure or lengths outside the supported int range
  now return -1; the old routine had no safe handling for these cases.
- `scripts/`, `tests/`, `.github/workflows/arm64.yml`, `.gitignore`: add
  isolated regression/build/architecture checks, packaging and native CI.
- Documentation and `LICENSES/`: record provenance, full notices, reproducible
  commands, installation/recovery and actual validation limits.

Transliteration rules, dictionaries, autocorrect data, nibs and icons remain
unchanged. Existing credits and third-party notices are preserved. The stock
Credits pane describes the historical release; NOTICES.md identifies the
distance implementation used by this community build.

The community's new code and changes are offered under MPL 1.1, consistent
with the upstream application's express notice. Existing third-party terms
remain applicable to their respective components; this is not a relicensing
of all inherited material. Corresponding source accompanies the release.
