class Toowl < Formula
  desc "GPU-accelerated terminal with Claude Code integration (the Claude Feather)"
  homepage "https://toowl.dev"
  version "1.0.49"
  license "Apache-2.0"

  # Linux ships prebuilt binaries from .github/workflows/release.yml. Each
  # release uploads:
  #   toowl-x86_64-unknown-linux-gnu.tar.gz
  #   toowl-aarch64-unknown-linux-gnu.tar.gz
  #   SHA256SUMS                                (consumed below)
  #
  # macOS has NO prebuilt binary this release — the macOS CI build is gated
  # off (decision 2026-06-12) — so the macOS path builds from source off the
  # tagged GitHub source tarball. Signed/notarized prebuilt macOS = follow-up.
  #
  # The release workflow regenerates SHA256SUMS on every tag — the
  # update-formula job (see homebrew/README.md) rewrites the sha256
  # lines below in this file using those values, then opens a PR to
  # the homebrew-tap repo.

  on_macos do
    # Build from source: no prebuilt macOS artifact ships this release.
    url "https://github.com/1martianway/toowl/archive/refs/tags/v#{version}.tar.gz"
    # sha256 of the tag ARCHIVE (not the `gh api .../tarball` endpoint — the
    # two differ in top-level dir prefix, so their bytes differ). Maintained
    # by scripts/update-homebrew-formula.sh on every release.
    sha256 "726eafe82c470489ba054388ce01475e81dc7b215fb2c938f1c14267e163051e"
    depends_on "rust" => :build
  end

  on_linux do
    on_arm do
      url "https://github.com/1martianway/toowl/releases/download/v#{version}/toowl-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c7dfe3d0f56327254bfbc4046b5d67f94ae08fc9821e720cc11726b0162bc7ea"
    end
    on_intel do
      url "https://github.com/1martianway/toowl/releases/download/v#{version}/toowl-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "60a558aa64e77e16f31ca1223513b1ac9d5aaa4a032e7be914490140465ffb58"
    end
  end

  def install
    if OS.mac?
      # Compile the GUI binary from the tagged source tree.
      system "cargo", "install", *std_cargo_args(path: "crates/toowl-app")
    else
      bin.install "toowl"
    end
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

      Then open the Perch with Ctrl+Shift+B (all platforms) — your
      Claude Code sessions in the current directory show up there.

      Docs:   https://toowl.dev
      Issues: https://github.com/1martianway/toowl/issues
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toowl --version")
  end
end
