cask "plex-media-server" do
  version "1.40.0.7998,c29d4c0c8"
  sha256 "3e593e2621e0def9fbe7346ad442852ff0c4e6755de992e0e4f54a0100d8704a"

  url "https://downloads.plex.tv/plex-media-server-new/#{version.csv.first}-#{version.csv.second}/macos/PlexMediaServer-#{version.csv.first}-#{version.csv.second}-universal.zip"
  name "Plex Media Server"
  desc "Home media server"
  homepage "https://www.plex.tv/"

  livecheck do
    url "https://plex.tv/api/downloads/5.json"
    regex(%r{href=.*?/PlexMediaServer-(\d+(?:\.\d+)*)-([\da-f]+)-universal\.zip}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Plex Media Server.app"
  binary "#{appdir}/Plex Media Server.app/Contents/MacOS/Plex Media Scanner", target: "plexms"

  uninstall launchctl: "com.plexapp.mediaserver",
            quit:      "com.plexapp.plexmediaserver"

  zap trash: [
    "~/Library/Application Support/Plex Media Server/",
    "~/Library/Caches/PlexMediaServer/",
    "~/Library/Logs/Plex Media Server/",
    "~/Library/Preferences/com.plexapp.plexmediaserver.plist",
  ]
end
