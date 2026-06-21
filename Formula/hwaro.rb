# typed: strict
# frozen_string_literal: true

# This file is rendered by hwaro's release pipeline (.github/workflows/publish-homebrew.yml).
# DO NOT EDIT by hand.
class Hwaro < Formula
  desc "Lightweight and fast static site generator (SSG) written in Crystal"
  homepage "https://github.com/hahwul/hwaro"
  version "0.16.0"
  license "MIT"

  on_macos do
    # macOS binaries are dynamically linked; openssl@3 is the only non-system
    # dependency (enforced by an otool guard in release-binary.yml).
    depends_on "openssl@3"

    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.16.0/hwaro-v0.16.0-osx-arm64"
      sha256 "e1d52a6973f92709019001451df860f8b25e9ba3cb537e60c86d1cb401fba16d"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.16.0/hwaro-v0.16.0-osx-x86_64"
      sha256 "10ff276f0947bda2ad276ad985369b1c0f5dc4ab79fd1851e95899d8750c66c3"
    end
  end

  on_linux do
    # Linux release binaries are statically linked (musl), so they are self-contained.
    on_arm do
      url "https://github.com/hahwul/hwaro/releases/download/v0.16.0/hwaro-v0.16.0-linux-arm64"
      sha256 "c56d64ef028466086a087441ec417182ac3d5069d1befa3b0360ee1f8bc7f273"
    end
    on_intel do
      url "https://github.com/hahwul/hwaro/releases/download/v0.16.0/hwaro-v0.16.0-linux-x86_64"
      sha256 "301ff7bd165735d069f70564fcdaa5ce74933fef5dfcdfd91e474ba757f87127"
    end
  end

  def install
    bin.install Dir["hwaro-v0.16.0-*"].first => "hwaro"
  end

  test do
    system "#{bin}/hwaro", "version"
  end
end
