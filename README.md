# Homebrew tap for Aqueous

[Aqueous](https://github.com/lifthrasiir/aqueous) is an archive format and an archiver, `aqr`,
built around lossless recompression.

```sh
brew install lifthrasiir/aqueous/aqr            # aqr alone (macOS, Linux)
brew install --cask lifthrasiir/aqueous/aqueous # Aqueous.app with Finder's services, and aqr (macOS)
```

Both install the binaries of the release (macOS: universal, Linux: x86_64 and aarch64, glibc of
Ubuntu 22.04 on); only one of the two can be installed at a time, each linking `aqr`.

Aqueous.app is signed ad hoc, not notarized: the cask removes its quarantine attribute (so that
Gatekeeper does not block `aqr` run from a terminal), and says so after installing.

## Updating

`./update.sh [TAG]` points the formula and the cask at a release (the latest by default), with
the SHA-256s GitHub gives for its assets.

The workflow `update` does it, then installs and tests both and pushes: on each release published
(lifthrasiir/aqueous's workflow `homebrew` dispatches it), by hand, and daily.
