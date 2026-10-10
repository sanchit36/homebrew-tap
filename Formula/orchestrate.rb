class Orchestrate < Formula
  desc "Run a spec's tickets through Claude Code sessions and merge the results"
  homepage "https://github.com/sanchit36/orchestrate"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.0/orchestrate-aarch64-apple-darwin.tar.xz"
      sha256 "b2b49b9ef5880a1f88702f7cea2b6112aa735e578ac7d13a2733cce2fb9f0bfe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.0/orchestrate-x86_64-apple-darwin.tar.xz"
      sha256 "a88faa14ea7e0845b2be28d1ad90c3196b31b39137898a1602f2e0e40c9dc678"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.0/orchestrate-aarch64-unknown-linux-musl.tar.xz"
      sha256 "07e086adddff3d8445e198ad734be1bdfea92ad7ff1e352f9c300946d345bbcf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.0/orchestrate-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6a718b502d9f846023d2dcd01659fab43e2d43b033f6fce66fcc17e8f75e0562"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "orchestrate"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "orchestrate"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "orchestrate"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "orchestrate"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
