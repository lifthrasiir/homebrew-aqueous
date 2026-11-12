cask "aqueous" do
  version "0.0.20261112"
  sha256 "77332a2ca866f1b67695a3c100741e4130f0c3a63229663ef6a9f43e958016e6"

  url "https://github.com/lifthrasiir/aqueous/releases/download/v#{version}/aqr-#{version.patch}-mac.zip"
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
