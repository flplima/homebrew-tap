cask "tmuxy" do
  version "0.1.9"
  sha256 "7a08bcf2efa52e4844b46fbb73629f7b895b4d319733e5d34b6de53724fad8cd"

  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_universal.dmg"
  name "tmuxy"
  desc "Desktop UI for tmux"
  homepage "https://tmuxy.sh/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "tmux"
  depends_on :macos

  app "tmuxy.app"
  binary "#{appdir}/tmuxy.app/Contents/MacOS/tmuxy"

  zap trash: [
    "~/.config/tmuxy",
    "~/.local/bin/tmuxy",
    "~/.local/share/tmuxy",
    "~/Library/Application Support/com.tmuxy.app",
    "~/Library/Application Support/tmuxy",
    "~/Library/Caches/com.tmuxy.app",
    "~/Library/WebKit/com.tmuxy.app",
  ]
end
