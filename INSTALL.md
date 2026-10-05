# Install the experimental Apple Silicon build

Unofficial community-maintained iAvro fork by Akil; not an official OmicronLab release.

This prerelease is for **Apple Silicon and macOS 27 or later**. It is ad-hoc
signed and **not notarized by Apple**. macOS may block the downloaded app.
The local Gatekeeper assessment rejected this ad-hoc build (exit 3); it is
not a download that has passed Apple's distribution checks.
Only the macOS 27.0.1 environment listed in TESTING.md has been tested; a newer
OS or another machine is not automatically covered by that result.

## Before installation

Keep **ABC** enabled as a fallback in System Settings → Keyboard → Text Input
→ Edit. Save your work. If you already use Avro, select ABC and make a verified
backup of the existing app before changing its installation.

Check both `/Library/Input Methods` and `~/Library/Input Methods`. Keep only
one active Avro installation. Move an old copy outside both directories into
a dated backup folder; preserve it. A system-wide copy may require an
administrator prompt. Quit only the old Avro process normally if it is still
running. Do not delete preferences or learned data.

## Install and activate

1. Download the arm64 ZIP and `SHA256SUMS` from this fork's release page.
   Verify the download with `shasum -a 256 -c SHA256SUMS` in the download folder
   after downloading both ZIPs listed in that file, or compare the arm64 ZIP's
   individual `shasum -a 256` result with its entry.
2. Extract the arm64 ZIP. In Finder choose Go → Go to Folder, enter
   `~/Library/Input Methods`, and create that directory if needed.
3. Copy **Avro Keyboard.app** from the extracted package into that directory.
   Do not open or install the source archive as an app.
4. Log out and back in after saving work if Avro does not appear in Input
   Sources. Add/select **Avro Keyboard** under the Bengali input sources.
5. With TextEdit focused, select Avro and physically type `ami` then Space.
   Expect `আমি`. Test suggestions, Backspace, punctuation and ABC/Avro
   switching before using it for important work.

If macOS blocks this unnotarized build, review Apple's
[instructions for opening trusted apps](https://support.apple.com/en-us/102445).
Use only the system's per-app approval if you trust this particular download.
If macOS does not offer it, stop and retain ABC or your previous installation.
Do not disable Gatekeeper/SIP, clear quarantine with a shell command or grant
broad Accessibility/Input Monitoring permissions as a workaround.

## Restore the previous version

Select ABC, save work and quit only the test Avro process normally. Move the
test app to a separate backup location, then put your verified previous app
back in its original directory. Leave preferences and learned data intact.
Log out/in if registration requires it and select the restored input source.
Keep both copies until you have verified recovery.

Report the OS/build, app version, affected application and exact typed keys
when reporting a problem. Diagnostic logs may contain typed text; redact them
before sharing. Full runtime coverage, including clean-account registration
and downloaded-artifact Gatekeeper behavior, is listed in TESTING.md.
