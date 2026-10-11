class Orchestrate < Formula
  desc "Run a spec's tickets through Claude Code sessions and merge the results"
  homepage "https://github.com/sanchit36/orchestrate"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.2/orchestrate-aarch64-apple-darwin.tar.xz"
      sha256 "afa16bf9d6787adecd7455e0f5911b162dfd38dd21d04b8ce2c37a2405bd3889"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.2/orchestrate-x86_64-apple-darwin.tar.xz"
      sha256 "b02fb8738906dcbb9589dcc9891eb8bbdab9838f576565494e8ff9165fc8a49c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.2/orchestrate-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8bec1f22838c21aeedbee0202c256d93772ad3a297fc5e99481deb27cae3f28f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanchit36/orchestrate/releases/download/v0.1.2/orchestrate-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f4e8f697409bbe5bc34438a660c343a70eacdcd8ed67ef65159dacf05807b043"
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
