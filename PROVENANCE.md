# Source, data and distribution provenance

Inventory of the checkout at upstream commit
`107a73283ac34a33faf7f6799c2e9dbfa97e6643`, reviewed 2026-10-05. No inherited
license notice was removed and no new blanket license is assigned here.

There is no top-level LICENSE/COPYING file in that revision. However,
`Credits.rtfd/TXT.rtf` explicitly says "Avro Keyboard for Mac is licensed under
MPL 1.1" and contains third-party notices. This is positive licensing evidence;
the absence of a top-level license must not be described as absence of all
license information. Public GitHub visibility is not used as permission.

| Material | Evidence in this checkout | Remaining distribution work |
| --- | --- | --- |
| App, parser and other OmicronLab Objective-C sources | Headers credit Rifat Nabi/OmicronLab, ©2012, all rights reserved; Credits names MPL 1.1 | Confirm scope for inherited files and supply applicable license/source notices for a modified binary |
| `data.json`, `regex.json`, `database.db3`, `autodict.dct` | Original resources; Credits attributes Data & Dictionary to Sumaiya Nazmun and Mehdi Hasan Khan | No per-file license statement found; confirm redistribution scope for rules, dictionary and autocorrect data |
| `avro.icns`, `Icons/*.png`, `Credits.rtfd` images and nib artwork | Credits attributes graphics to Tanbin Islam Siyam and M. M. Rifat-Un-Nabi; lists Dortmund Icon Set by PC.DE | Map individual assets to authors; Credits only says "CC 3.0" for Dortmund, without a complete variant/license identification |
| `English.lproj` nibs, strings and `preferences.plist` | Inherited app resources | Confirm coverage under the application license; preserve attribution and packaged credits |
| `RegexKitLite.h/.m` | Full BSD-style three-clause terms in source, ©2008–2010 John Engelhart; Credits also reproduces terms | Preserve source/binary notices and reconcile source/credits year ranges when preparing notices |
| `FMDatabase*`, `FMResultSet*` | Credits reproduces MIT terms, ©2008 Flying Meat Inc.; attributes FMDB to August "Gus" Mueller | Retain full notice and identify exact vendored revision if needed; no separate package manifest identifies it |
| `NSString+Levenshtein.h/.m` | ©2009 Stefano Pigozzi, all rights reserved; attribution in Credits | No explicit permission text located for this category; clarify applicable terms |
| System Cocoa/Foundation/InputMethodKit, ICU, SQLite, libobjc/libSystem | Linked from the selected Apple SDK/system; no copied binary libraries | Record system linkage; do not package developer-machine copies |
| New regression fixtures | Output captured from unmodified upstream parser/rules; see `tests/README.md` | Preserve provenance; snapshots are not a newly licensed replacement dataset |

Credits can be inspected without editing it:

```sh
textutil -convert txt -stdout Credits.rtfd/TXT.rtf
```

The runtime/build work leaves original data, icons, credits and dependency
sources unchanged. It does not resolve the open distribution questions above.
Before packaging a public binary, obtain clarification for ambiguous inherited
material, collect required complete notices/source materials, review neutral
branding and record answers against exact files/revisions. Do not infer
permission from an unanswered request, a public fork or upstream PR status.

Use the description: **Unofficial community-maintained iAvro fork by Akil; not
an official OmicronLab release.** Developer ID signing, hardened-runtime
evaluation, notarization, packaging and downloaded-artifact tests remain a
separate release phase. Public distribution is pending these provenance and
release checks; no request to an upstream author has been sent.
