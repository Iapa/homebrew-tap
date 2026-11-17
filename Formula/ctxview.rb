class Ctxview < Formula
  desc "Local Context Window Inspector and reverse-proxy analyzer for LLM coding agents"
  homepage "https://github.com/Iapa/ctxview"
  version "0.1.0"
  license "MIT"
  head "https://github.com/Iapa/ctxview.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Iapa/ctxview/releases/download/v#{version}/ctxview_#{version}_darwin_arm64.tar.gz"
      sha256 "f1a4e23e2d5d5d2ef2209da95f80b6ddc4f7a0324fd26d5bb0d6982c89cc9dbc"
    else
      url "https://github.com/Iapa/ctxview/releases/download/v#{version}/ctxview_#{version}_darwin_amd64.tar.gz"
      sha256 "763404ef5b4b44acc0e7fdb87b1830b6039c97aa8e55736d2dccce8ae50ca7a7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Iapa/ctxview/releases/download/v#{version}/ctxview_#{version}_linux_arm64.tar.gz"
      sha256 "bb29236dfec1f6f75258f4d4c9180411d425d35ecb0462e6e8b825fd925dc319"
    else
      url "https://github.com/Iapa/ctxview/releases/download/v#{version}/ctxview_#{version}_linux_amd64.tar.gz"
      sha256 "f6644b5c4fe0d6d3b94efc11a433d6d410663caba1b9b57fe7c024b37e16634d"
    end
  end

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "."
    else
      bin.install "ctxview"
    end
  end

  service do
    run [opt_bin/"ctxview"]
    environment_variables CTXVIEW_PORT: "8787"
    keep_alive true
    log_path var/"log/ctxview.log"
    error_log_path var/"log/ctxview.log"
  end

  test do
    assert_match(/\S+/, shell_output("#{bin}/ctxview -version").strip)
  end
end

