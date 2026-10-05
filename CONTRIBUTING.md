# Contributing

Keep patches small and keep Objective-C, Avro transliteration, dictionaries and
UI behavior intact unless a specific behavior change has been agreed. arm64 is
the release target. Do not add Universal/Intel support, replace dependencies
speculatively, or remove upstream build settings merely because they look old.

Before editing, read repository instructions and inspect `git status` and
`git diff`. Preserve local work. Use an external build directory or disposable
checkout for experiments. The untracked modernization guide is a local user
artifact, not application source.

Open this folder in VS Code and use its terminal to run `./scripts/check.sh`.
For a product change, run the relevant checks after each logical edit and
record errors/warnings. A final fresh checkout with only the proposed patch
should pass the documented checks without existing DerivedData. Runtime
changes also need the manual matrix in [TESTING.md](TESTING.md); mocks do not
replace native InputMethodKit tests.

Include the trigger, confirmed cause, affected files, changed behavior,
toolchain/OS, exact validation command and remaining limitations in a review.
Keep warning cleanup separate from compatibility fixes unless a warning
explains a confirmed failure. Preserve exact Unicode output and cite fixture
provenance when touching the engine. Never raise the minimum OS solely because
the current test machine runs a newer version.

Do not commit logs, DerivedData, app bundles, signing credentials, provisioning
profiles, personal Xcode state or learned input data. Keep sensitive diagnostic
logs local and redact before sharing. CI must not run privileged PR code or
use release-signing secrets. Follow [PROVENANCE.md](PROVENANCE.md) before adding
or redistributing inherited material; do not assign it a new blanket license.

Installation, process termination, logout, external publication and changes
requiring administrator access need the user's authorization. Let the user
handle local administrator prompts. Do not weaken security protections to
make an input method run. Never commit, push, open a PR or publish on another
person's behalf without an explicit instruction to do so.
