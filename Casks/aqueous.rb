cask "aqueous" do
  version "0.0.20261118"
  sha256 "52549f29e40f04322f1679204a2290eefdd4f74b4423c60802b2a5dd7fae96b0"

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
