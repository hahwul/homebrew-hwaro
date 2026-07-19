# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.18.0"
  license "MIT"

  on_macos do
    # macOS release archives are self-contained: scripts/package-macos.sh bundles
    # every Homebrew-linked dylib (OpenSSL and its deps) next to the binary and
    # rewrites load paths to @executable_path/lib, so no brew dependency is needed.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.18.0/hwaro-v0.18.0-osx-arm64.tar.gz"
      sha256 "16135a06bcd75408f15d695e435e743da154f57a8c58b33a153e1c6400993b68"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.18.0/hwaro-v0.18.0-osx-x86_64.tar.gz"
      sha256 "1c8c1bd239b9ec967c4689847c92b2f094eb9a006b855784dd1adec3cfd532fa"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.18.0/hwaro-v0.18.0-linux-arm64"
      sha256 "3b05a18b72dd8633a33a3204c1b23c513e76fa1da89aa43ea8d3efd1dab78c29"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.18.0/hwaro-v0.18.0-linux-x86_64"
      sha256 "530fea168771503a4f4a4bd1f3c440a98434ba56ca78f681202d6ebda5efd410"
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
