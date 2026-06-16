class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.30"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "578e9d2c6821bbfcf518d1c23ac03534b61c4cd6b33c3c589461480946bb6831"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "5dd96eda2fbc8ff03f9f54d45b8031e9c8284b8ef303223102fde018d48aaf4b"
  end

  def install
    bin.install Dir["tmuxy_*.AppImage"].first => "tmuxy"
  end

  # Homebrew 6.0+ sandboxes post_install ($HOME is read-only),
  # so .desktop/icon install runs outside brew via caveats.
  def caveats
    <<~EOS
      To add tmuxy to your application menu, run once:
        #{bin}/tmuxy --appimage-extract usr/share 2>/dev/null; \\
        mkdir -p ~/.local/share/applications ~/.local/share/icons; \\
        sed 's|Exec=.*|Exec=#{bin}/tmuxy gui|;s|Icon=.*|Icon=tmuxy|;s|StartupWMClass=.*|StartupWMClass=tmuxy|' \\
          squashfs-root/usr/share/applications/tmuxy.desktop \\
          > ~/.local/share/applications/tmuxy.desktop; \\
        cp -r squashfs-root/usr/share/icons/hicolor ~/.local/share/icons/; \\
        rm -rf squashfs-root
    EOS
  end

  test do
    assert_path_exists bin/"tmuxy"
  end
end
