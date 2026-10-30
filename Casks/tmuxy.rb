cask "tmuxy" do
  version "0.1.4"
  sha256 "52a2c721a0f4b2b2cb1e34aeb5373a32f5c586b062b01723ea97a41773201d49"

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
