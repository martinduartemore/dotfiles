cask "silico" do
  version "0.128.0"
  sha256 "68d0c4a5afa3f1edb320de24b045726330be7ffa278c38da2632f19cf9cbf908"

  url "https://ddtqf80bu4kgq.cloudfront.net/stable/Silico-#{version}-universal.dmg"
  name "Silico"
  desc "Goodfire's Silico desktop app"
  homepage "https://www.goodfire.ai/"

  livecheck do
    url "https://ddtqf80bu4kgq.cloudfront.net/stable/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true

  app "Silico.app"
end
