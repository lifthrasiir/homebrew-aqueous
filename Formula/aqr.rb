class Aqr < Formula
  desc "Archiver built around lossless recompression"
  homepage "https://lifthrasiir.github.io/aqueous/"
  version "0.0.20261118"
  license "MIT-0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release's builds: on macOS aqr is taken out of Aqueous.app (universal, signed ad hoc).
  on_macos do
    url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261118/aqr-20261118-mac.zip"
    sha256 "52549f29e40f04322f1679204a2290eefdd4f74b4423c60802b2a5dd7fae96b0"
  end
  on_linux do
    on_intel do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261118/aqr-20261118-linux-x86_64.tar.xz"
      sha256 "13a2da864c23e400d2eae0f57b46ddc8a9642b3f73de9b9762866161566f5387"
    end
    on_arm do
      url "https://github.com/lifthrasiir/aqueous/releases/download/v0.0.20261118/aqr-20261118-linux-aarch64.tar.xz"
      sha256 "4785c85e11baea8ec1517e1a1f6228ecbccaae19adf1ae676f5ceea323c3a0b1"
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
