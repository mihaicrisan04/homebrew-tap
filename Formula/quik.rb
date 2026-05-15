class Quik < Formula
  desc "Inline AI prompt for your zsh session. Cmd+Enter, ask anything, streams in place"
  homepage "https://github.com/mihaicrisan04/quik"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mihaicrisan04/quik/releases/download/v0.1.0/quik-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "19646fb23cff250d701dfe5928386d0625e016c50659aecf40de016e271378cc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mihaicrisan04/quik/releases/download/v0.1.0/quik-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "37adf381a0c1323c41eaa313b436d98bb87d66b437173fea8d1d7bc4c150b3eb"
    end
    on_intel do
      url "https://github.com/mihaicrisan04/quik/releases/download/v0.1.0/quik-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0aad4a8da264580a5f31c43be80910e46c0a3a89e70bfc2b271c4b8e52875345"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "quik"
    pkgshare.install "shell/quik.plugin.zsh"
    doc.install "README.md", "LICENSE"
    (doc/"docs").install Dir["docs/*"]
  end

  def caveats
    <<~EOS
      To enable the Cmd+Enter prompt, add this to your ~/.zshrc:

        source "#{opt_pkgshare}/quik.plugin.zsh"

      You also need at least one backend CLI on your PATH:
        - claude (https://docs.claude.com/en/docs/claude-code)
        - codex  (https://github.com/openai/codex)

      Pick one with: export QUIK_BACKEND=claude  (or codex, or leave unset for auto)

      Terminal-specific keybind setup:
        #{opt_share}/doc/quik/docs/keybinds.md
    EOS
  end

  test do
    assert_match(/^quik \d+\.\d+\.\d+/, shell_output("#{bin}/quik --version"))
  end
end
