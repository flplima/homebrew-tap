class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.40"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "e3200e7c54e1c31c3c9223d67ec8a80049d49f31a5eeb8e7d2fe83afd9bd3c02"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "ddea582a46d58bed3940c946f7044533999757ea8e9e1edaf4786372efc6495c"
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
