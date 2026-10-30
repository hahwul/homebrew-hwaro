# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.22.0"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.22.0/hwaro-v0.22.0-osx-arm64.tar.gz"
      sha256 "fd74eae1e8d7f65a3cb7511a0ad9f7769bc28d1be2aabf9649e256b2994e8946"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.22.0/hwaro-v0.22.0-osx-x86_64.tar.gz"
      sha256 "c23b08137e772c3804772cf328e9db87f8d3e2167ced3b07ca1f3a89e72b03ea"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.22.0/hwaro-v0.22.0-linux-arm64"
      sha256 "78d99c133f31ee28353ad9f753370e7193727c16cbf8e86d18ca0e8fb5d0a8d1"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.22.0/hwaro-v0.22.0-linux-x86_64"
      sha256 "3ed4bae9cdc9c171887c11eb9ad36661a574e65f34145a6539a593fcdb1f4075"
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
