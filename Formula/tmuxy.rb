class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.34"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "761633ec80bc59015afeb2fdc5260aba3e3ade8243383169e57e64b9f4c8cdde"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "132773ffaab6f2cd0d3c58cfd1b84aa344aebb18fceaee4da17bc6ec540f96fa"
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
