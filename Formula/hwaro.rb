# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.20.2"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.2/hwaro-v0.20.2-osx-arm64.tar.gz"
      sha256 "67b588972c026023bfde92277e2d4cdb99d6334fff3cb72a5510c97477f742fa"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.2/hwaro-v0.20.2-osx-x86_64.tar.gz"
      sha256 "855afaf2af25ac7c00aec19d4475ffb2fba3ae0cb6325719cbd6e2ecb4b38fc3"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.2/hwaro-v0.20.2-linux-arm64"
      sha256 "2b168f4e792a9c020162e2b7c5bead02acb800ec9e951262f2fc1fec8299429d"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.2/hwaro-v0.20.2-linux-x86_64"
      sha256 "aa61fa4c66f6b371ab2c2c9cd2e283b40eea479a94c41b9d0b03816db7693828"
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
