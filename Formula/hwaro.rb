# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.22.1"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.22.1/hwaro-v0.22.1-osx-arm64.tar.gz"
      sha256 "03e85f7dc171716c32c570810176fd87c3b9349f5f8910c8f3e0f71bb0f6d5a0"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.22.1/hwaro-v0.22.1-osx-x86_64.tar.gz"
      sha256 "f4dba814f13ca6fcf35a069f9ec3c967aba8b2127e552ffe3738d1e9b7ced769"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.22.1/hwaro-v0.22.1-linux-arm64"
      sha256 "f1581da8077025d485b8628eb9211d134ea6f9eca1ac6496ed016d6f722ec262"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.22.1/hwaro-v0.22.1-linux-x86_64"
      sha256 "64f047f1e43cdda3d96f0699d79d2beb3dbf177b89846406132e72da96e18371"
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
