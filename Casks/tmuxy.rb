cask "tmuxy" do
  version "0.1.8"
  sha256 "3e7377a177a0a186bc10e14431b910937424cfd449a763f4ca0a6d6652ce98e9"

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
