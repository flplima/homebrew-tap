class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.55"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "3a57dbe3a7a5e1b76948fdf0191f90dcb740c14588251cf958fbbd52d439fc68"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "7d86d48227491fd8f28af7fb86fbe3f03a6617660bdbb9d42f42d0f4aec83443"
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
