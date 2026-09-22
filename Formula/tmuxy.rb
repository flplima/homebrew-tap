class Tmuxy < Formula
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"
  version "0.0.10-alpha.64"

  depends_on :linux
  depends_on "tmux"

  on_arm do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_aarch64.AppImage"
    sha256 "d1e63de9cad296354444a5218522f4439644842f8860cb9bee2198b5a6af2bb9"
  end

  on_intel do
    url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_amd64.AppImage"
    sha256 "4de1fc8b1ef4595a87af58105da95677341ea6d501e427d43f3154dfe594d085"
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

  # `assert_path_exists` only proved a file landed — it would pass on
  # a truncated download, an AppImage for the wrong arch, or a build
  # that cannot start. This runs the thing: version out of the binary
  # that was installed, then the server serving its page on a free
  # port. APPIMAGE_EXTRACT_AND_RUN because `brew test` has no FUSE.
  test do
    assert_path_exists bin/"tmuxy"

    ENV["APPIMAGE_EXTRACT_AND_RUN"] = "1"
    assert_match "tmuxy #{version}", shell_output("#{bin}/tmuxy --version")

    port = free_port
    # `spawn` wants Strings; `bin/"tmuxy"` is a Pathname.
    pid = spawn((bin/"tmuxy").to_s, "server", "--port", port.to_s)
    begin
      page = nil
      20.times do
        sleep 1
        # `|| true` so a connection refused while the server is still
        # binding is a retry, not an exception. The assert below is
        # what decides the test.
        page = shell_output("curl -fsS http://127.0.0.1:#{port}/ || true")
        break if page.include?("<html")
      end
      assert_match "<html", page.to_s
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
