cask "tmuxy" do
  version "0.0.10-alpha.78"
  sha256 "79f8f843c982cec4363d6730fc5b25a1087354b48fa739cf2b5c7f474e7a7af5"

  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_universal.dmg"
  name "tmuxy"
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"

  auto_updates false
  depends_on formula: "tmux"
  depends_on :macos

  app "tmuxy.app"

  # `postflight_steps` is a declarative list Homebrew runs, sandboxed,
  # after the app is installed; Homebrew 7 deprecated the plain-Ruby
  # `postflight` block in its favour. Steps name their paths so the
  # sandbox knows what to let them write: `{{appdir}}` is expanded
  # by Homebrew, and `base: :home` roots a path at the user's home.
  # The release workflow's verify-brew-cask job checks the wrapper
  # actually lands: on a Homebrew that predated `postflight_steps`
  # (alpha.63) the block parsed cleanly and did nothing.
  postflight_steps do
    # Homebrew marks the downloaded app with Gatekeeper's quarantine
    # attribute, which puts a one-time "downloaded from the Internet"
    # prompt in front of the first launch even for a notarized app.
    # Removing it keeps that launch frictionless.
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/tmuxy.app"],
        must_succeed: false

    # Record the app binary path and install a CLI wrapper at
    # ~/.local/bin/tmuxy so `tmuxy pane list` etc. work immediately
    # after install, without opening the GUI first.
    mkdir_p ".config/tmuxy", base: :home
    mkdir_p ".local/bin", base: :home
    write_file ".config/tmuxy/launcher", "{{appdir}}/tmuxy.app/Contents/MacOS/tmuxy\n", base: :home
    write_file ".local/bin/tmuxy", <<~WRAPPER, base: :home
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
    set_permissions ".local/bin/tmuxy", "0755", base: :home, recursive: false
  end

  zap trash: [
    "~/.config/tmuxy",
    "~/.local/bin/tmuxy",
    "~/Library/Application Support/com.tmuxy.app",
    "~/Library/Application Support/tmuxy",
    "~/Library/Preferences/com.tmuxy.app.plist",
    "~/Library/Saved Application State/com.tmuxy.app.savedState",
  ]
end
