# Testing and troubleshooting

## Evidence record — 2026-10-05

The following is the Phase 3 record before PR publication. Base commit:
`107a73283ac34a33faf7f6799c2e9dbfa97e6643`, branch
`feat/macos-27-apple-silicon`, with uncommitted arm64/controller fixes and the
checks/docs in this change. This is not a tagged release.

| Environment/artifact | Build and isolated checks | Native input-method runtime |
| --- | --- | --- |
| macOS 27.0.1 (26A434), arm64, Xcode 27.0 (27A266a), SDK 27.0 (26A425), Debug | PASS in separate build directory | PASS for requested typing matrix, user-reported |
| Same toolchain, fresh disposable checkout, Debug | PASS, xcodebuild exit 0; all isolated checks PASS | No reinstall; installed source-equivalent Debug covered above |
| Same toolchain, fresh disposable checkout, Release | PASS, xcodebuild exit 0; all isolated checks PASS | NOT TESTED |
| GitHub `macos-26` ARM64 / Xcode 26.6 | Workflow prepared; NOT RUN remotely | NOT TESTED |
| Other OS versions, machines, clean user accounts | NOT TESTED | NOT TESTED |

Local compiler: Apple clang 21.0.0 (`clang-2100.3.34.2`). Debug builds use a
valid ad-hoc signature with `get-task-allow`; the Release build also has this
entitlement. Neither is a Developer ID or notarized release. No signing
workaround was required.

Automated checks: eight controller commit cases, 15 byte-exact upstream parser
fixtures, resource/plist loading, SQLite integrity, regex/dictionary lookup
and autocorrect/emoticon loading. All passed in fresh Debug and Release builds.
The commit harness also failed as expected against the unchanged upstream
controller (exit 1), confirming it detects the original commit regression. One bundled
Mach-O is arm64 only; nine direct system dependencies have ARM64 loaded
headers; there are no `LC_RPATH` entries or developer-machine library paths.
See [fixture provenance and limitations](tests/README.md).

The full Debug and Release builds each report 46 existing warning lines: 24 integer-narrowing,
17 deprecated API, and one each for a tautological comparison, nonliteral
format string, undeclared delegate `-menu`, traditional headermap, and
bundle-identifier/build-setting mismatch. Incremental builds can report fewer
warnings and must not be compared as if they were full builds. Tests introduce
no additional compiler warnings. The original settings and
dependency sources remain intact.

Clean-checkout procedure: create a detached disposable worktree at the base
commit, apply only the reviewed tracked diff and new check/documentation files,
and run `./scripts/check.sh` with separate empty output directories for Debug
and Release. All 69 source/documentation files matched the primary checkout;
the local user guide and prior DerivedData were excluded. No commit was made.
The later entitlement-display command adjustment was verified separately on
both built artifacts; no product source changed after these builds.

## Experimental release changes — 2026-10-06

The fork's release candidate adds metadata version 1.0.0/build 10001,
hardened runtime and suppression of injected debugging entitlements in
Release. A valid ad-hoc signature shows the runtime flag and no
`com.apple.security.get-task-allow`. No Developer ID signing identity is
available; notarization is NOT PERFORMED.
The read-only local `spctl --assess --type execute --verbose=4` check returned
exit 3, rejected. No protection was disabled to change that result. This is
recorded separately from valid code-signature integrity.

The owner authorized an independent replacement of the distance routine
whose original redistribution terms could not be verified. The replacement
passes 400 captured original distance pairs, nil input and eight real
dictionary candidate-order comparisons, alongside all earlier checks.
The full Release build passes with 44 existing warning lines: the two
narrowing warnings from the replaced routine are gone. There are no new
test-source compiler warnings.

The prior Debug manual confirmation predates these release-only protections
and the independently tested routine replacement. Interactive testing of the
exact final Release package, clean-account installation and Gatekeeper's
per-app approval path remain NOT TESTED. Do not present the earlier Debug
typing confirmation as a test of the downloadable Release artifact.

## Manual result and repeatable matrix

The user confirmed the repaired app works after selecting Avro. The requested
cross-application matrix was followed by the overall confirmation "I tested
it works." Record this as **user-reported PASS for the requested matrix**;
individual keystrokes were not independently recorded or automated.

| Application | Requested checks | Result |
| --- | --- | --- |
| TextEdit | Composition, suggestions, editing, punctuation, ABC/Avro switching | User-reported PASS (grouped confirmation) |
| Chrome | Same checks in a normal editable text area | User-reported PASS (grouped confirmation) |
| VS Code | Same checks in a disposable text file | User-reported PASS (grouped confirmation) |

Repeat in each application with Avro selected and **physical typing**, not
pasted Bengali text:

1. Type `ami` then Space; confirm `আমি` is inserted.
2. Type `bangla` without committing; inspect suggestions, choose one by click,
   then repeat using arrow selection and Return.
3. Type `bangla`, press Backspace once, retype `a`, then Space; check editing.
4. Type `ami, bangla.`; inspect punctuation and word boundaries.
5. Switch to ABC and type `hello123`, then back to Avro and type `ami` + Space.
6. Check newline and moving between the three apps without stuck composition.

ABC fallback, installed executable path/ARM64 process, signature and bundle
configuration were independently verified during the installation session.
Preferences and learned-data files were preserved and checked at installation.
Preference editing/save/reopen, learning persistence across sessions,
cancellation edge cases, a full rollback/reinstall cycle, clean-account
registration, Gatekeeper acceptance of a downloaded artifact and notarization
remain **NOT TESTED**. A short log sample without errors is not proof that all
runtime paths are safe.

## Confirmed runtime failure and repair

Before the repair, Bengali suggestions appeared but neither Space nor clicking
inserted text. LLDB stopped on
`-[__NSSingleObjectArrayI insertText:replacementRange:]: unrecognized selector`
inside `candidateSelected:`. The cached `_currentClient` was an array, while
`[self client]` was the framework's `_IPMDServerClientWrapperLegacy`.

The controller now uses `[self client]` for insertion. Keyboard commit also
uses the remembered candidate, or the first candidate, when the panel returns
nil; an explicit panel selection takes priority. The nil selection was
observed during debugging. Empty candidate lists do not trigger insertion.
No transliteration, dictionary, resource, preference or UI layout was changed.

This evidence establishes the stale receiver and missing selection in the
tested failure. Permissions, sandboxing, quarantine and InputMethodKit removal
were not confirmed causes. No broad permissions or disabled protections were
needed.

## Reversible local installation and rollback

The check script never installs anything. Before a separately authorized
manual installation:

1. Keep ABC enabled in System Settings → Keyboard → Text Input → Edit and
   verify it works in TextEdit. Save documents. Select ABC before replacing an
   active input method.
2. Inspect both `/Library/Input Methods` and `~/Library/Input Methods` for
   existing copies. Make an independent backup outside both directories with
   `ditto`, preserving metadata. Verify the copied bundle's contents and
   signature before moving the installed copy. Do not overwrite an old backup.
3. Preserve `com.omicronlab.inputmethod.AvroKeyboard` preferences and
   `~/Library/Application Support/OmicronLab/Avro Keyboard`. Export preferences
   with `defaults export` when present; copy learned data without resetting it.
   Keep any `com.apple.HIToolbox` preferences backup for investigation; do not
   wholesale restore input-source settings as a routine installation step.
4. Ask the user to quit the identified old Avro process normally if required.
   Do not stop unrelated input services. Move an old system-wide app into the
   verified backup directory through Finder; let the user authorize any
   administrator prompt locally. Keep the original and independent backup.
5. Copy the verified built app into `~/Library/Input Methods/Avro Keyboard.app`
   with `ditto`. Verify contents against the build and repeat `codesign
   --verify --strict`, `file`/`lipo`, plist and dependency checks. Avoid
   duplicate bundle identifiers in both installation directories.
6. Let the user log out/in if registration requires it; never do so
   automatically. Select Avro Keyboard in Input Sources while the test app has
   focus, then run the manual matrix. Do not bypass a security prompt.

For rollback, select ABC, save work and normally quit only the verified test
process with permission. Move the test app out of Input Methods into a new
backup location, then restore the verified original to its original location.
Let the user handle administrator prompts and any logout/login. Leave current
preferences and learning intact unless there is specific evidence they need
restoration and the user approves. Verify the restored signature/architecture
and test it. Do not delete backups during recovery.

In this session the original Intel app and an independent copy remain parked
outside Input Methods, and the failed Debug app is also retained. The working
arm64 Debug app is installed only in the user's Input Methods directory. The
private installation report records exact backup paths and manifests; these
machine-specific backups are not repository artifacts.

## Troubleshooting

- **Missing/disabled Avro:** verify its actual installed path, bundle ID,
  `InputMethodConnectionName`, controller class and executable. Check for
  duplicate copies. Ask for logout/login only after preserving work and
  verifying registration; do not assume compilation registers an input method.
- **Suggestions appear but nothing inserts:** inspect the active client's
  exception and insertion path. Compare the running executable to the repaired
  build. An attached debugger can pause input; use ABC and obtain permission
  before attaching to or stopping a live process.
- **Launch/signature failure:** record `codesign --verify --strict --verbose=2`
  and `codesign -d --verbose=4 --entitlements - --xml` output, bundle metadata and
  quarantine attributes. A valid local ad-hoc signature does not establish
  Gatekeeper acceptance for downloaded software. Do not clear quarantine,
  disable SIP/Gatekeeper, grant broad TCC permissions or alter sandboxing as a
  speculative fix.
- **Relevant logs:** a narrow local query is
  `log show --last 10m --style compact --predicate 'process == "Avro Keyboard"'`.
  Logs can contain typed text. Keep them private; redact before sharing. Mark
  inaccessible logs and tests that were not performed explicitly.

The experimental release corrects the inherited bundle-name placeholder and
version metadata. The existing bundle-ID/build-setting warning remains; it
did not block compilation or the earlier tested typing path.
