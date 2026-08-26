class Toowl < Formula
  desc "GPU-accelerated terminal with Claude Code integration (the Claude Feather)"
  homepage "https://toowl.dev"
  version "1.11.24"
  license :cannot_represent

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

  # Artifacts come from dl.toowl.dev, not github.com. The toowl repo is
  # private, so every github.com/1martianway/toowl/... URL 404s for anyone
  # outside the org — which is exactly what made `brew install` impossible
  # even though the tap itself is public. The gateway holds a read-only token
  # and serves the same bytes; source stays private, binaries do not.

  on_macos do
    # No macOS artifact has ever been published: publish-macos failed on every
    # release because toowl-app declared a git dependency on the private
    # toowl-pro repo and a clean runner could not authenticate to resolve it.
    # Fixed — Pro depends on OSS now — so v1.10.0 is the first release with a
    # universal macOS binary, and this block should point at it then.
    #
    # Building from the source tarball is NOT an option meanwhile: that
    # archive is served by github.com and is equally private. A formula that
    # cannot fetch is worse than one that says why.
    odie <<~EOS
      No macOS build of toowl is published yet.

      The macOS binary ships with v1.10.0. On Linux, toowl installs today:
        curl -fsSL https://toowl.dev/install.sh | sh
    EOS
  end

  on_linux do
    on_arm do
      url "https://dl.toowl.dev/v1/toowl/download/v#{version}/toowl-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "be8c40a8d18d2b85fab2c4df3ac8bace4b8daea71630a72930b2352e0be50658"
    end
    on_intel do
      url "https://dl.toowl.dev/v1/toowl/download/v#{version}/toowl-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2ea1c08fb5c6c9edec85c4e1fbb759a1b6f8b1847b28e8c1396c0794765c9e18"
    end
  end

  def install
    # macOS never reaches here — on_macos odies above, because no macOS
    # artifact exists yet and the source tarball is private. When v1.10.0
    # publishes toowl-universal-apple-darwin.tar.gz, replace that odie with a
    # url/sha256 pair and this stays a plain bin.install for both platforms.
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
