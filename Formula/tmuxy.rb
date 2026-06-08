class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.26"
  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
  sha256 "f1fe8b288c279dc4dec4661cbd534ab67b71374afdaa67f2b3a9de870e25c30e"

  depends_on :linux
  depends_on "tmux"

  def install
    # Brew stages the downloaded AppImage under its original name.
    # Install it as the `tmuxy` executable. The AppImage is
    # self-contained; running it needs FUSE (libfuse2) at runtime.
    bin.install "tmuxy_#{version}_amd64.AppImage" => "tmuxy"
  end

  test do
    assert_path_exists bin/"tmuxy"
  end
end
