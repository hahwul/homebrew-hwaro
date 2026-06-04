# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.15.3"
  license "MIT"

  on_macos do
    # macOS binaries are dynamically linked; openssl@3 is the only non-system
    # dependency (enforced by an otool guard in release-binary.yml).
    depends_on "openssl@3"

    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.15.3/hwaro-v0.15.3-osx-arm64"
      sha256 "d0a4ac12605d16194d7cd1c87c89f50b96a627f377512edad668ad500813cc6a"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.15.3/hwaro-v0.15.3-osx-x86_64"
      sha256 "59fecb7f9666cd4782c101fe439c1584f50eb393c279e1e23c892f12e00f412b"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.15.3/hwaro-v0.15.3-linux-arm64"
      sha256 "c5505f9d8716f0dfb55eba8d52d7aa1338503216bdd4112f5171298bc4d50070"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.15.3/hwaro-v0.15.3-linux-x86_64"
      sha256 "383b23d9e4f7f519b14efcbdfc529009813ba6309bc4f9d8bcf97c6c4926a3ab"
    end
  end

  def install
    bin.install Dir["hwaro-v0.15.3-*"].first => "hwaro"
  end

  test do
    system "#{bin}/hwaro", "version"
  end
end
