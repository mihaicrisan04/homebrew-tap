class Airdrop < Formula
  desc "AirDrop files and URLs to nearby Apple devices from the terminal"
  homepage "https://github.com/mihaicrisan04/airdrop"
  url "https://github.com/mihaicrisan04/airdrop/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "57097badaabbb2b54471b9b4a0ae195963d2aeb34d5d13e70d6a863a26888676"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on macos: :ventura
  depends_on xcode: :build

  def install
    system "swiftc", "-O", "-framework", "AppKit",
                     "-o", "airdrop", "Sources/main.swift"

    app_dir = libexec/"Airdrop.app/Contents/MacOS"
    app_dir.mkpath
    app_dir.install "airdrop"
    (libexec/"Airdrop.app/Contents").install "Info.plist"

    system "codesign", "--force", "--sign", "-", libexec/"Airdrop.app"

    (bin/"ad").write <<~SHELL
      #!/bin/sh
      exec "#{app_dir}/airdrop" "$@"
    SHELL
    chmod 0755, bin/"ad"
  end

  test do
    assert_match(/^ad \d+\.\d+\.\d+/, shell_output("#{bin}/ad --version"))
  end
end
