cask "tmuxy" do
  version "0.1.0"
  sha256 "da238859fed8a7ac53c3c1b5224433fa0803149aac100f900489cdd0674f7dca"

  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_universal.dmg"
  name "tmuxy"
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on formula: "tmux"
  depends_on :macos

  app "tmuxy.app"
  binary "#{appdir}/tmuxy.app/Contents/MacOS/tmuxy"

  zap trash: [
    "~/.config/tmuxy",
    "~/.local/bin/tmuxy",
    "~/Library/Application Support/com.tmuxy.app",
    "~/Library/Application Support/tmuxy",
    "~/Library/Preferences/com.tmuxy.app.plist",
    "~/Library/Saved Application State/com.tmuxy.app.savedState",
  ]
end
