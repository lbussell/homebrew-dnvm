class Dnvm < Formula
  desc "Command-line interface for installing and updating dotnet SDKs"
  homepage "https://dnvm.net"
  url "https://github.com/dn-vm/dnvm.git",
      tag:      "v1.1.2",
      revision: "ff50ec0b039261c85fa807a6d0dfb85319064fa6"
  license "GPL-3.0"

  depends_on "dotnet" => :build

  def install
    # Determine the .NET RID for the current platform
    if OS.mac?
      os = "osx"
    else
      os = "linux"
    end
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
  end

  test do
    assert_match "usage: dnvm", shell_output("#{bin}/dnvm --help")
  end
end
