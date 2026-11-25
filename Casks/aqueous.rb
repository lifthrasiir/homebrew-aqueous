cask "aqueous" do
  version "0.0.20261126"
  sha256 "da3fef88d23d8da50c342645750da5cf6c0e936af33bb5ee35f5c65abc178bd0"

  # (the asset's name is not always of the version: update.sh writes it)
  url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261126/aqr-20261126-mac.zip"
  name "Aqueous"
  desc "Archiver built around lossless recompression, with Finder's services"
  homepage "https://lifthrasiir.github.io/aqueous/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Aqueous.app"
  binary "#{appdir}/Aqueous.app/Contents/MacOS/aqr"

  # (signed ad hoc, not notarized: quarantined, Gatekeeper would block aqr run from a terminal)
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Aqueous.app"]
  end

  zap trash: "~/Library/Preferences/org.mearie.aqueous.plist"

  caveats <<~EOS
    Aqueous.app is signed ad hoc, not notarized by Apple. This cask has removed its
    quarantine attribute, so Gatekeeper does not check it before it runs.
    Install it only if you trust the release of lifthrasiir/aqueous it comes from.
  EOS
end
