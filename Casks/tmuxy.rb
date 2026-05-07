cask "tmuxy" do
  version "0.0.1"
  sha256 "486d9ce1b21bf9b35c8ddc44a422306312be216e18c6406282257f4018121fd7"

  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_universal.dmg"
  name "tmuxy"
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"

  auto_updates false

  app "tmuxy.app"

  zap trash: [
    "~/.config/tmuxy",
    "~/.local/bin/tmuxy",
    "~/Library/Application Support/com.tmuxy.app",
    "~/Library/Preferences/com.tmuxy.app.plist",
    "~/Library/Saved Application State/com.tmuxy.app.savedState",
    "~/tmuxy-debug.log",
  ]
end
