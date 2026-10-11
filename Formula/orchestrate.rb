class Orchestrate < Formula
  desc "Run a spec's tickets through Claude Code sessions and merge the results"
  homepage "https://github.com/sanchit36/orchestrate"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.1/orchestrate-aarch64-apple-darwin.tar.xz"
      sha256 "1577da9c5443b919ad27c1bf5271758302b3c2bbcb53d6d365ad657f5e25ef79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.1/orchestrate-x86_64-apple-darwin.tar.xz"
      sha256 "9cba10013ccdf21c05692c1b5a0f6545f98a0e00f9bd39293a015b2751533e3c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.1/orchestrate-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9b27a89ca7df911d4d0a8591e9c982b28d81177928332212f123ffa54c190c10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.1/orchestrate-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a6a5391fa581e09e02fef5a7b6ed1b04839eea0073d0a38313316d88c7cda9d7"
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
