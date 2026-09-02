# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.20.1"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.1/hwaro-v0.20.1-osx-arm64.tar.gz"
      sha256 "e88e549f92ef3b25d66f1ac17ee198fc09af38660ecd6f8cf4098e15cb2779d9"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.1/hwaro-v0.20.1-osx-x86_64.tar.gz"
      sha256 "7ce59700e95ba2233d47396d777379dcf4d475c403279b4637c6faf822f04ae2"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.1/hwaro-v0.20.1-linux-arm64"
      sha256 "10b091efc43406673f349c2f0ff3e85b51f49fc1c9d572adcc44446d76543f31"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.1/hwaro-v0.20.1-linux-x86_64"
      sha256 "a5a98baa19b44f20ef27f04a5069a4e2541df60eb98cd968e3fa84a09000797a"
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
