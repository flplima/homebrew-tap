cask "tmuxy" do
  version "0.0.10-alpha.62"
  sha256 "464456cf1d88a142b6b587152bfa97784e36e321afd2a44a0296c55afd04ff60"

  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_universal.dmg"
  name "tmuxy"
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"

  auto_updates false

  depends_on formula: "tmux"

  app "tmuxy.app"

  # Homebrew marks the downloaded app with Gatekeeper's quarantine
  # attribute, which puts a confirmation dialog in front of the first
  # launch. Removing it keeps that first launch frictionless.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/tmuxy.app"],
        must_succeed: false

    # Record the app binary path and install a CLI wrapper at
    # ~/.local/bin/tmuxy so `tmuxy pane list` etc. work immediately
    # after install, without opening the GUI first.
    write_file "~/.config/tmuxy/launcher",
               "{{appdir}}/tmuxy.app/Contents/MacOS/tmuxy\n"

    write_file "~/.local/bin/tmuxy", <<~'WRAPPER'
      #!/bin/sh
      set -eu
      LAUNCHER_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/tmuxy/launcher"
      if [ ! -f "$LAUNCHER_FILE" ]; then
        echo 'tmuxy: no launcher recorded — open the app once first.' >&2
        exit 1
      fi
      EXEC_PATH="$(cat "$LAUNCHER_FILE")"
      if [ "$#" -gt 0 ]; then exec "$EXEC_PATH" "$@"; fi
      APP_PATH="${EXEC_PATH%%/Contents/MacOS/*}"
      if [ "$APP_PATH" != "$EXEC_PATH" ] && [ -d "$APP_PATH" ]; then
        exec /usr/bin/open "$APP_PATH"
      fi
      exec "$EXEC_PATH"
    WRAPPER
    set_permissions "~/.local/bin/tmuxy", "0755"
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
