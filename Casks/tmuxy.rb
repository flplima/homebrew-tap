cask "tmuxy" do
  version "0.0.10-alpha.14"
  sha256 "e734b9b55ff4f45357896cb7ac8dc276d138cdb3d4f5f40ab249b268fd914ab7"

  url "https://github.com/flplima/tmuxy/releases/download/v#{version}/tmuxy_#{version}_universal.dmg"
  name "tmuxy"
  desc "Web-based tmux interface"
  homepage "https://github.com/flplima/tmuxy"

  auto_updates false

  app "tmuxy.app"

  # Strip Gatekeeper's quarantine attribute so macOS Sequoia's
  # "Apple could not verify..." dialog doesn't block the first
  # launch. Brew stopped doing this automatically in 2022; for
  # an unsigned + un-notarized app there's no other way to ship
  # a frictionless first launch without paying for the Apple
  # Developer Program.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/tmuxy.app"],
                   sudo: false
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
