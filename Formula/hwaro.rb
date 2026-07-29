# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.18.1"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.18.1/hwaro-v0.18.1-osx-arm64.tar.gz"
      sha256 "fa06f033ced347cd043948ef0d481d1fe0bda8bcf418c364556ba7a04e86d3bf"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.18.1/hwaro-v0.18.1-osx-x86_64.tar.gz"
      sha256 "a687c98a95ae249795a0603958adb3e94789450d11098488a296869af53cc7ef"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.18.1/hwaro-v0.18.1-linux-arm64"
      sha256 "34e7d87e2555a697a87d1423418f926781380e2e3bf57efe96e0951e23ad8227"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.18.1/hwaro-v0.18.1-linux-x86_64"
      sha256 "f88254a07cee4aa9d50c50836c523b034beb20f62cb5da21a6125ac214d992d8"
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
