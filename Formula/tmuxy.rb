class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.56"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "d995ddb36c5e0b1dbe03e258ac2e1fe5b221f7171dc3a615fcb6cf5e7b98dece"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "48574a6fd51d76580463422ac2af6eff1105ae0fe06e5d68bbe14d283a85c189"
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
