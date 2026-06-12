class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.27"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "19c38af5769d753115cfd74c1c6fba6c6bf7e94e6a32b56790b08c24cc9b5835"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "c7a231d02db46781739095d8bd0e81a592173f5ef94cead5fd4fd87a95805e05"
  end

  def install
    # Brew stages the downloaded AppImage under its original name
    # (the arch suffix varies). Install whichever was fetched as
    # the `tmuxy` executable. The AppImage is self-contained;
    # running it needs FUSE (libfuse2) at runtime.
    bin.install Dir["tmuxy_*.AppImage"].first => "tmuxy"
  end

  test do
    assert_path_exists bin/"tmuxy"
  end
end
