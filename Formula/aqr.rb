class Aqr < Formula
  desc "Archiver built around lossless recompression"
  homepage "https://lifthrasiir.github.io/aqueous/"
  version "0.0.20261110"
  license "MIT-0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release's builds: on macOS aqr is taken out of Aqueous.app (universal, signed ad hoc).
  on_macos do
    url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261110/aqr-20261110-mac.zip"
    sha256 "f937464a75c980621f20a316c25753f65c168253ba3a34baa1a33f033df7ad42"
  end
  on_linux do
    on_intel do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261110/aqr-20261110-linux-x86_64.tar.xz"
      sha256 "d514a7f1258be87b3c50df3decfededc4921d552f314bd9103ee291781d099cc"
    end
    on_arm do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261110/aqr-20261110-linux-aarch64.tar.xz"
      sha256 "4bec3b539e70257affdf7eb24289b5fab48166ca8116c0272457131db616c175"
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
