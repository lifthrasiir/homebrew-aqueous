class Aqr < Formula
  desc "Archiver built around lossless recompression"
  homepage "https://lifthrasiir.github.io/aqueous/"
  version "0.0.20261126"
  license "MIT-0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release's builds: on macOS aqr is taken out of Aqueous.app (universal, signed ad hoc).
  on_macos do
    url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261126/aqr-20261126-mac.zip"
    sha256 "da3fef88d23d8da50c342645750da5cf6c0e936af33bb5ee35f5c65abc178bd0"
  end
  on_linux do
    on_intel do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261126/aqr-20261126-linux-x86_64.tar.xz"
      sha256 "13cea9437e7671e49c5a4b2b49112f7266906983478c24b05a611ea610e7714d"
    end
    on_arm do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261126/aqr-20261126-linux-aarch64.tar.xz"
      sha256 "08cb8da7c13306965b4419205ab4ca550f6b909888f836e8f032c72b90f7e6df"
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
