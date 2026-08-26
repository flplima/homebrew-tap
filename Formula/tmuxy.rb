class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.49"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "33df4bce5e420d3f806f8a603053379c63eada06ade5cf252926195d2532672f"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "dbd5ec03bfc6a6fbfc4a02f9269d6eef7fe16cf3fdcd2266737505bb98a0f981"
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
