class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.28"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "0cee27b5337d777c2845f5f386605dd47ee794bbe49a7abecad2f21b0cf54207"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "af6e6bb7b53f9781c1becf68e15d4bfc405516dae7b7ad357608c6439b3d37a7"
  end

  def install
    bin.install Dir["tmuxy_*.AppImage"].first => "tmuxy"
  end

  def post_install
    # Create a .desktop file so tmuxy appears in the OS app menu.
    apps = share/"applications"
    apps.mkpath
    (apps/"tmuxy.desktop").write <<~DESKTOP
      [Desktop Entry]
      Name=tmuxy
      Comment=Web-based tmux interface
      Exec=#{bin}/tmuxy gui
      Icon=tmuxy
      Terminal=false
      Type=Application
      Categories=System;TerminalEmulator;
      StartupWMClass=tmuxy
    DESKTOP

    # Extract icons from the AppImage and install all resolutions.
    system "#{bin}/tmuxy", "--appimage-extract", "usr/share/icons"
    Dir["squashfs-root/usr/share/icons/hicolor/*/apps/tmuxy.png"].each do |icon|
      size = File.basename(File.dirname(File.dirname(icon)))
      dest = share/"icons/hicolor"/size/"apps"
      dest.mkpath
      cp icon, dest/"tmuxy.png"
    end
    rm_rf "squashfs-root"

    # Linuxbrew's share/ isn't on the standard XDG search path,
    # so symlink into ~/.local/share/ where desktop environments
    # actually look for .desktop files and icons.
    user_apps = Pathname.new(Dir.home)/".local/share/applications"
    user_apps.mkpath
    ln_sf apps/"tmuxy.desktop", user_apps/"tmuxy.desktop"

    user_icons = Pathname.new(Dir.home)/".local/share/icons"
    (share/"icons/hicolor").children.select(&:directory?).each do |size_dir|
      src = size_dir/"apps/tmuxy.png"
      next unless src.exist?
      dest = user_icons/"hicolor"/size_dir.basename/"apps"
      dest.mkpath
      ln_sf src, dest/"tmuxy.png"
    end
  end

  test do
    assert_path_exists bin/"tmuxy"
  end
end
