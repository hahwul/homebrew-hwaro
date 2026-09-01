# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.20.0"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.0/hwaro-v0.20.0-osx-arm64.tar.gz"
      sha256 "dab0916b64cf400e9a53c40bc38db801edd09aaefa230b3bce9d1d1108cb205d"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.0/hwaro-v0.20.0-osx-x86_64.tar.gz"
      sha256 "0c4e67dbc435ce62bad8ba27775d51ba1158b77d6cb83b3746a7f6c1f0813455"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.0/hwaro-v0.20.0-linux-arm64"
      sha256 "5a7be8275b5882c144f02085bebd79ffa6023bb5b7cdcb2554a3bc97242c9fce"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.20.0/hwaro-v0.20.0-linux-x86_64"
      sha256 "ad265919ecde196e5ae57913b13cca09e7078ea1122a3dd911ea2492569bb653"
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
