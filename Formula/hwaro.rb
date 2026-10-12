# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.21.0"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.21.0/hwaro-v0.21.0-osx-arm64.tar.gz"
      sha256 "08c83d0baa4c56b637845a81c10ec4a35246c295a5d47e6a7a6b0ead15f93142"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.21.0/hwaro-v0.21.0-osx-x86_64.tar.gz"
      sha256 "8bb175648c0fca95cc86a10682307c76cb3bc14184c0a3217fdac7506afafdac"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.21.0/hwaro-v0.21.0-linux-arm64"
      sha256 "749c95a2b86ce0d89d986786b930ad64e6625e9ce48a3cc17e17e843d2dc82ce"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.21.0/hwaro-v0.21.0-linux-x86_64"
      sha256 "002576fd135f9e7bc779e48d35e3ce10c3770b1c6a01cce6c685dd0819519846"
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
