# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.19.0"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.19.0/hwaro-v0.19.0-osx-arm64.tar.gz"
      sha256 "237b3c66a432d3ab490fba0262bdd64c44a149a06304ae8b7d3c710a9faa4c22"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.19.0/hwaro-v0.19.0-osx-x86_64.tar.gz"
      sha256 "ea51aefe488f1fa95c324d95b50d4fb346759a8a9d34187e236a240b2deeeb8a"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.19.0/hwaro-v0.19.0-linux-arm64"
      sha256 "f9df67747a69f84d4c73fb5db7646c6ea0ceb4e1235ac5d482e4151f25d2e17c"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.19.0/hwaro-v0.19.0-linux-x86_64"
      sha256 "ad5d789ca34d7d429b1b87603c4e5babe811133127082fccc1f0da052e781669"
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
