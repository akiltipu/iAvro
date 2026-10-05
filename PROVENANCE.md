# Source, data and distribution provenance

Base: upstream `107a73283ac34a33faf7f6799c2e9dbfa97e6643`. Updated 2026-10-06
for the experimental community package. Original attribution and notices are
preserved. No license is inferred from public GitHub visibility.

The original `Credits.rtfd/TXT.rtf` expressly states that Avro Keyboard for
Mac is licensed under MPL 1.1. The application-level declaration is the
license evidence used for the original app and its bundled original data and
resources; no separate per-resource grant has been located. Third-party
components with identified terms are treated separately below. The package
includes full license copies, modification history and matching source.

| Material | Evidence and packaging treatment |
| --- | --- |
| OmicronLab app/controller/parser sources | Original headers credit Rifat Nabi/OmicronLab, copyright 2012. Original Credits expressly declares MPL 1.1; preserve notices and provide corresponding modified source. |
| data.json, regex.json, database.db3, autodict.dct | Unchanged original application resources. Credits names Sumaiya Nazmun and Mehdi Hasan Khan for Data & Dictionary. Included under the original application-level MPL declaration; no independent per-file license statement was found. |
| avro.icns, nibs, strings, preferences and credit artwork | Unchanged original app resources. Graphics credit: Tanbin Islam Siyam and M. M. Rifat-Un-Nabi. Preserve existing artwork/attribution; no separate grant for every individual image has been located. Trademark ownership is not transferred or asserted. |
| Icons/AutoCorrect.png, Credits.png, General.png | Commit f146a19637558df7235f17f320c8b7112fbe85e3 adds these with the Dortmund Icon Set credit to PC.DE. The original RTF's hyperlink explicitly points to https://creativecommons.org/licenses/by/3.0 even though its visible text only says CC 3.0. This corrects the earlier plain-text-only audit. Include CC BY 3.0 and attribution; images unchanged. |
| RegexKitLite.h/.m | Full BSD-style three-clause notice in source, copyright 2008–2010 John Engelhart. Preserve it and the earlier year range in original Credits. |
| FMDatabase*, FMResultSet* | Original Credits reproduces MIT terms, copyright 2008 Flying Meat Inc., and attributes FMDB to August “Gus” Mueller. Preserve full notice. Exact vendored package version remains unidentified. |
| Former NSString+Levenshtein implementation | Original Credits links pigoz/imal; source credits Stefano Pigozzi, copyright 2009. That repository and the copied files provide no license we could verify. No grant from Pigozzi is claimed. The user authorized an independent replacement; the original implementation is absent from the release build and source archive. |
| Replacement distance routine and community changes | Copyright 2026 AkilTipu, MPL 1.1; see MODIFICATIONS.md. API, UTF-16 distance and ordinary candidate ordering verified against captured original results. |
| Cocoa/Foundation/InputMethodKit, ICU, SQLite, libobjc/libSystem | Apple SDK/system linkage; no copied system libraries in the package. |
| Regression fixtures | Outputs captured from original source before changes, with source hashes in tests/README.md; compatibility snapshots rather than a new linguistic specification. |

## License copies

- `LICENSES/MPL-1.1.txt`: Mozilla's full text linked by its official MPL 1.1 page,
  https://www.mozilla.org/media/MPL/1.1/index.0c5913925d40.txt.
- `LICENSES/CC-BY-3.0.txt`: official Creative Commons legal text, retrieved from
  https://github.com/creativecommons/cc-legal-tools-data/blob/main/docs/licenses/by/3.0/legalcode.txt
  when the direct legalcode URL returned HTTP 403 to the command-line client.
- `LICENSES/RegexKitLite-BSD.txt`: verbatim notice from the existing header.
- `LICENSES/FMDB-MIT.txt`: verbatim notice from the existing Credits document.

The records above distinguish explicit upstream license evidence from
per-file provenance gaps. They do not establish an independent grant from
every original contributor or claim ownership of third-party trademarks.
The release retains the publisher's original application-level statement;
it does not silently replace inherited terms with MIT or another license.
No upstream author's permission was fabricated or inferred from the user's
approval to publish this fork.

Branding: **Unofficial community-maintained iAvro fork by Akil; not an official
OmicronLab release.** Developer ID signing and notarization are not available
for this experimental build. See NOTICES.md and INSTALL.md.
