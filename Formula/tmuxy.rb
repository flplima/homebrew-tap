class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.25"
  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
  sha256 "e3333e4f40b31f86f292cc462d52334e0b0a4075ba38bd0e2d60e867685c4644"

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
