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

    contents = libexec/"Airdrop.app/Contents"
    macos_dir = contents/"MacOS"
    resources = contents/"Resources"
    macos_dir.mkpath
    resources.mkpath
    macos_dir.install "airdrop"
    contents.install "Info.plist"

    if File.exist?("AppIcon.png")
      iconset = buildpath/"AppIcon.iconset"
      iconset.mkpath
      sizes = [
        [16,   "icon_16x16.png"],      [32,   "icon_16x16@2x.png"],
        [32,   "icon_32x32.png"],      [64,   "icon_32x32@2x.png"],
        [128,  "icon_128x128.png"],    [256,  "icon_128x128@2x.png"],
        [256,  "icon_256x256.png"],    [512,  "icon_256x256@2x.png"],
        [512,  "icon_512x512.png"],    [1024, "icon_512x512@2x.png"],
      ]
      sizes.each do |dim, name|
        system "sips", "-z", dim.to_s, dim.to_s, "AppIcon.png", "--out", iconset/name, out: File::NULL
      end
      system "iconutil", "-c", "icns", iconset, "-o", resources/"AppIcon.icns"
    end

    system "codesign", "--force", "--sign", "-", libexec/"Airdrop.app"

    (bin/"ad").write <<~SHELL
      #!/bin/sh
      exec "#{macos_dir}/airdrop" "$@"
    SHELL
    chmod 0755, bin/"ad"
  end

  test do
    assert_match(/^ad \d+\.\d+\.\d+/, shell_output("#{bin}/ad --version"))
  end
end
