class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.57"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "4da1673482383815e4f36ae237037ce1262c3bea80e3e913b34669d7381edaca"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "d4467f6887c093f02146874dacbb9ee5db483c4deeeb616613dad0d6d0e5475d"
  end

  def install
    bin.install Dir["tmuxy_*.AppImage"].first => "tmuxy"
  end

  # The applications-menu entry cannot be installed from here:
  # Homebrew 6 sandboxes post_install with a read-only $HOME, and
  # Homebrew's own share/applications is not on XDG_DATA_DIRS. The
  # app registers itself on launch instead (see
  # packages/tmuxy-tauri-app/src/desktop.rs).
  def caveats
    <<~EOS
      Run `tmuxy` once to add it to your applications menu.
      Set TMUXY_NO_DESKTOP_ENTRY=1 to skip that.
    EOS
  end

  test do
    assert_path_exists bin/"tmuxy"
  end
end
