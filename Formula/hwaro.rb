# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.17.0"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.17.0/hwaro-v0.17.0-osx-arm64.tar.gz"
      sha256 "49756822c657f3bdcf99597dbe61dae3a109a4f3fe5d33c37c877d1b99f2c072"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.17.0/hwaro-v0.17.0-osx-x86_64.tar.gz"
      sha256 "621ced9fca0c66249f29b44ec3376ebbe307baf5cb88ebd0bef91ed8c44c3e0d"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.17.0/hwaro-v0.17.0-linux-arm64"
      sha256 "934ff01b2f5121a1b9c4ccc69da24a51b8656e6dea8fffacce0f21e99956ec09"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.17.0/hwaro-v0.17.0-linux-x86_64"
      sha256 "fb2cf8fb1f4819132e4418067a875b27f44bc3346f4d7fd8855d560f928506bd"
    end
  end

  def install
    if OS.mac?
      # The macOS tarball extracts to `hwaro` + `lib/*.dylib`. Keep them together
      # in libexec (the binary resolves dylibs via @executable_path/lib) and expose
      # the CLI through a symlink; execve canonicalizes the symlink so
      # @executable_path still points at libexec.
      libexec.install "hwaro", "lib"
      bin.install_symlink libexec/"hwaro"
    else
      bin.install Dir["hwaro-v#{version}-linux-*"].first => "hwaro"
    end
  end

  test do
    system "#{bin}/hwaro", "version"
  end
end
