class Aqr < Formula
  desc "Archiver built around lossless recompression"
  homepage "https://lifthrasiir.github.io/aqueous/"
  version "0.0.20261121"
  license "MIT-0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release's builds: on macOS aqr is taken out of Aqueous.app (universal, signed ad hoc).
  on_macos do
    url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261121/aqr-20261121-mac.zip"
    sha256 "d24d9fc16dd3ad4c84f6d705a44cd10c6abc8b569d6f5b294943a9ec940f1bf5"
  end
  on_linux do
    on_intel do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261121/aqr-20261121-linux-x86_64.tar.xz"
      sha256 "1817f7c4147efaf8bb91944ba65c8d67f59b3b43ebd43bf52fe9eeb484451a3f"
    end
    on_arm do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261121/aqr-20261121-linux-aarch64.tar.xz"
      sha256 "fc13972f61c03e1c9baea10a5667a02b1c12de86d28c57d936ca45af15a1e9d0"
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
