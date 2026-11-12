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
the SHA-256s GitHub gives for its assets, once each asset is checked against its SHA-256 and its
attestation of build provenance (made by lifthrasiir/aqueous's `release.yml` for the tag:
`gh attestation verify`). Anyone can check an asset the same way:

```sh
gh attestation verify aqr-STEM-mac.zip -R lifthrasiir/aqueous \
    --signer-workflow lifthrasiir/aqueous/.github/workflows/release.yml
```

The workflow `update` does it, then installs and tests both and pushes: on each release published
(lifthrasiir/aqueous's workflow `homebrew` dispatches it), by hand, and daily. The job that runs the
release's binaries reads only; the push is a job of its own, taking the formula and the cask
alone, and only if nothing but their versions, URLs and SHA-256s changed.
