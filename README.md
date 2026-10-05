# iAvro for Apple Silicon

Unofficial community-maintained iAvro fork by Akil; not an official OmicronLab release.

This fork keeps the original Objective-C InputMethodKit application, Avro
transliteration rules, dictionaries and candidate UI. The release target is
native **arm64**. Intel and Universal builds are outside this fork's release scope.

The current changes select arm64 and repair candidate insertion by using the
framework's current client, with a fallback when the candidate panel has no
explicit selection. No parser, dictionary or minimum-OS setting was changed.

Local Debug typing on macOS 27.0.1 has passed user testing. Automated checks and
their limits are recorded in [TESTING.md](TESTING.md). This remains development
work: the local ad-hoc builds are not notarized distribution artifacts.

From a native Apple Silicon Mac with full Xcode selected:

```sh
./scripts/check.sh
```

The command builds in a new temporary directory, runs isolated regression tests
and prints the evidence path. It does not install or launch the input method.

- [Build instructions and dependencies](BUILDING.md)
- [Manual testing, installation, rollback and troubleshooting](TESTING.md)
- [Contribution guidelines](CONTRIBUTING.md)
- [Provenance and unresolved distribution permissions](PROVENANCE.md)
- [Original upstream](https://github.com/omicronlab/iAvro)

Reference forks are [torifat/iAvro](https://github.com/torifat/iAvro) and
[aumi-sudo/iAvro-Apple-Silicon](https://github.com/aumi-sudo/iAvro-Apple-Silicon).
They contain broader changes, including a later Swift rewrite; their behavior
and runtime claims are not evidence for this Objective-C build.
