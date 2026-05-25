class Toowl < Formula
  desc "GPU-accelerated terminal with Claude Code integration (the Claude Feather)"
  homepage "https://toowl.dev"
  version "1.0.0"
  license "Apache-2.0"

  # URLs point at the release artifacts produced by
  # .github/workflows/release.yml. Each release uploads:
  #   toowl-universal-apple-darwin.tar.gz        (arm64+x86_64 lipo'd)
  #   toowl-x86_64-unknown-linux-gnu.tar.gz
  #   toowl-aarch64-unknown-linux-gnu.tar.gz
  #   SHA256SUMS                                (consumed below)
  #
  # The release workflow regenerates SHA256SUMS on every tag — the
  # update-formula job (see homebrew/README.md) rewrites the sha256
  # lines below in this file using those values, then opens a PR to
  # the homebrew-tap repo.

  on_linux do
    on_arm do
      url "https://github.com/1martianway/toowl/releases/download/v#{version}/toowl-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "89e1f4fbef54239b22c271dd4a8d3c625133adc5039fc7c8349961b23cfa9e52"
    end
    on_intel do
      url "https://github.com/1martianway/toowl/releases/download/v#{version}/toowl-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0b17ac1a4ac141f56072773292120af8ddc97eceb611d5fe2a5031aea9ddd0c6"
    end
  end

  def install
    bin.install "toowl"
  end

  def caveats
    <<~EOS
      toowl is now installed. To launch:

        toowl

      The first feather on the Perch is the Claude Feather. To use it
      with Claude Code, install the claude binary separately:

        # macOS
        brew install anthropic/claude/claude

        # any platform
        npm install -g @anthropic/claude

      Then open the Perch with Cmd+B (macOS) or Ctrl+B (Linux/Windows) —
      your Claude Code sessions in the current directory show up there.

      Docs:   https://toowl.dev
      Issues: https://github.com/1martianway/toowl/issues
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toowl --version")
  end
end
