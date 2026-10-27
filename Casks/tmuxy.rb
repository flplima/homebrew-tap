cask "tmuxy" do
  version "0.1.3"
  sha256 "5b6fed6eedc18059ecb8b63d7f395000d43e96454500c5404b117bbaeb40c182"

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
    "~/Library/Application Support/com.tmuxy.app",
    "~/Library/Application Support/tmuxy",
    "~/Library/Caches/com.tmuxy.app",
    "~/Library/WebKit/com.tmuxy.app",
  ]
end
