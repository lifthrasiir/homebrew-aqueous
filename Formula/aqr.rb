class Aqr < Formula
  desc "Archiver built around lossless recompression"
  homepage "https://lifthrasiir.github.io/aqueous/"
  version "0.0.20261112"
  license "MIT-0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release's builds: on macOS aqr is taken out of Aqueous.app (universal, signed ad hoc).
  on_macos do
    url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261112/aqr-20261112-mac.zip"
    sha256 "77332a2ca866f1b67695a3c100741e4130f0c3a63229663ef6a9f43e958016e6"
  end
  on_linux do
    on_intel do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261112/aqr-20261112-linux-x86_64.tar.xz"
      sha256 "39809560583d5b141b19fa639871c13662fc82c18ada7a3a4400e2e9352bc907"
    end
    on_arm do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261112/aqr-20261112-linux-aarch64.tar.xz"
      sha256 "164640ece9c05421cc511dec2174c8ff57b3e108d606f25a2afe7687e0d96173"
    end
  end

  conflicts_with cask: "aqueous", because: "the cask links its own aqr"

  def install
    # (the zip holds Aqueous.app alone, which Homebrew stages into)
    bin.install Dir["**/MacOS/aqr"].first || "aqr" => "aqr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqr --version")
    (testpath/"in/hello.txt").write "Hello, Aqueous!\n" * 100
    system bin/"aqr", "-c", "-q", "-o", "test.aqr", "in"
    system bin/"aqr", "-d", "-q", "-o", "out", "test.aqr"
    assert_equal (testpath/"in/hello.txt").read, (testpath/"out/hello.txt").read
  end
end
