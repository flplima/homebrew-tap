class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.39"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "92fb9a89f515bbb71837dc5aa3c7f660711395e3d10546064cee3f7b31143dc3"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "8b5084c925d37f3bca523efdba7646cafd215e1840ba25d8382896226ba1a3bd"
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
