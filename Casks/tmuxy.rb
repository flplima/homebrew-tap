cask "tmuxy" do
  version "0.0.10-alpha.66"
  sha256 "eefb0e4ed744d62f7eb19e142c2ed136e77188eef49b241c12fe44eaf55f37e2"

  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_universal.dmg"
  name "tmuxy"
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"

  auto_updates false

  depends_on formula: "tmux"

  app "tmuxy.app"

  # `postflight` is the stanza Homebrew runs after the app is
  # installed, and it is plain Ruby. A cask body silently ignores a
  # stanza it does not know — v0.0.10-alpha.63 shipped a
  # `postflight_steps do` block that parsed, installed, audited and
  # styled cleanly while doing nothing at all, so a brew install left
  # the user with the app and no `tmuxy` command.
  postflight do
    # Homebrew marks the downloaded app with Gatekeeper's quarantine
    # attribute, which puts a confirmation dialog in front of the
    # first launch. Removing it keeps that launch frictionless.
    system_command "/usr/bin/xattr",
                   args:         ["-dr", "com.apple.quarantine", "#{appdir}/tmuxy.app"],
                   must_succeed: false

    # Record the app binary path and install a CLI wrapper at
    # ~/.local/bin/tmuxy so `tmuxy pane list` etc. work immediately
    # after install, without opening the GUI first.
    launcher = File.expand_path("~/.config/tmuxy/launcher")
    FileUtils.mkdir_p File.dirname(launcher)
    File.write launcher, "#{appdir}/tmuxy.app/Contents/MacOS/tmuxy\n"

    wrapper = File.expand_path("~/.local/bin/tmuxy")
    FileUtils.mkdir_p File.dirname(wrapper)
    File.write wrapper, <<~'WRAPPER'
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
    FileUtils.chmod 0o755, wrapper
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
