cask "tmuxy" do
  version "0.1.6"
  sha256 "e2268aa09934e2b61fda7ac5847e8e5fd85623ce2abdc983165b14fac7cbcf9f"

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
    "~/.local/share/tmuxy",
    "~/.local/bin/tmuxy",
    "~/Library/Application Support/com.tmuxy.app",
    "~/Library/Application Support/tmuxy",
    "~/Library/Caches/com.tmuxy.app",
    "~/Library/WebKit/com.tmuxy.app",
  ]
end
