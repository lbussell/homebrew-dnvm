class Dnvm < Formula
  desc "Command-line interface for installing and updating dotnet SDKs"
  homepage "https://dnvm.net"
  url "https://github.com/dn-vm/dnvm.git",
      tag:      "v1.1.2",
      revision: "ff50ec0b039261c85fa807a6d0dfb85319064fa6"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/lbussell/homebrew-dnvm/releases/download/dnvm-1.1.2"
    sha256 cellar: :any,                 arm64_tahoe:  "5459a52c7ee07886d7459650a067053cc0cfdc0f6e48dee93da6670abf2525a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "18ecef77d8d517d747daa85aa68f1ae0ce42f4fb51957de047693046dd1950ac"
  end

  depends_on "dotnet" => :build
  depends_on "brotli"
  depends_on "openssl@3"

  def install
    # Determine the .NET RID for the current platform
    os = OS.mac? ? "osx" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    rid = "#{os}-#{arch}"

    args = %W[
      --configuration Release
      --self-contained
      --runtime #{rid}
      --output #{bin}
      -p:DebugType=None
      -p:DebugSymbols=false
    ]

    system "dotnet", "publish", "src/dnvm/dnvm.csproj", *args

    # Remove macOS debug symbol bundles
    rm_r(bin/"dnvm.dSYM") if (bin/"dnvm.dSYM").exist?
  end

  test do
    assert_match "usage: dnvm", shell_output("#{bin}/dnvm --help")
  end
end
