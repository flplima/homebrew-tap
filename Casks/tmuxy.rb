cask "tmuxy" do
  version "0.0.10-alpha.38"
  sha256 "2968bd62426a54b408a5a87df79e6ec8b467b62cd082643b3d1241ae9fdfa272"

  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_universal.dmg"
  name "tmuxy"
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"

  auto_updates false

  app "tmuxy.app"

  # Strip Gatekeeper's quarantine attribute so macOS Sequoia's
  # "Apple could not verify..." dialog doesn't block the first
  # launch. Brew stopped doing this automatically in 2022; for
  # an unsigned + un-notarized app there's no other way to ship
  # a frictionless first launch without paying for the Apple
  # Developer Program.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/tmuxy.app"],
                   sudo: false

    # Record the app binary path and install a CLI wrapper at
    # ~/.local/bin/tmuxy so `tmuxy pane list` etc. work immediately
    # after install, without opening the GUI first.
    exec_path = "#{appdir}/tmuxy.app/Contents/MacOS/tmuxy"
    config_dir = Pathname.new(Dir.home)/".config/tmuxy"
    config_dir.mkpath
    (config_dir/"launcher").write "#{exec_path}\n"

    bin_dir = Pathname.new(Dir.home)/".local/bin"
    bin_dir.mkpath
    wrapper = bin_dir/"tmuxy"
    wrapper.write "#!/bin/sh\n" \
      "set -eu\n" \
      "LAUNCHER_FILE=\"${XDG_CONFIG_HOME:-$HOME/.config}/tmuxy/launcher\"\n" \
      "if [ ! -f \"$LAUNCHER_FILE\" ]; then\n" \
      "  echo 'tmuxy: no launcher recorded — open the app once first.' >&2\n" \
      "  exit 1\n" \
      "fi\n" \
      "EXEC_PATH=\"$(cat \"$LAUNCHER_FILE\")\"\n" \
      "if [ \"$#\" -gt 0 ]; then exec \"$EXEC_PATH\" \"$@\"; fi\n" \
      "APP_PATH=\"${EXEC_PATH%%/Contents/MacOS/*}\"\n" \
      "if [ \"$APP_PATH\" != \"$EXEC_PATH\" ] && [ -d \"$APP_PATH\" ]; then\n" \
      "  exec /usr/bin/open \"$APP_PATH\"\n" \
      "fi\n" \
      "exec \"$EXEC_PATH\"\n"
    wrapper.chmod 0o755
  end

  zap trash: [
    "~/.config/tmuxy",
    "~/.local/bin/tmuxy",
    "~/Library/Application Support/com.tmuxy.app",
    "~/Library/Preferences/com.tmuxy.app.plist",
    "~/Library/Saved Application State/com.tmuxy.app.savedState",
    "~/tmuxy-debug.log",
  ]
end
