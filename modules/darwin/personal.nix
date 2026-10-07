{ ... }:
{
  # AnkerDockManager is left out: Anker publishes no stable download URL, and
  # the app's own update feed points at localhost.
  #
  # WhatsApp stays an undeclared App Store install. A single masApps entry
  # puts App Store apps in scope for `brew bundle` cleanup, which then
  # uninstalls every App Store app not listed (Pages, Keynote, iMovie...), and
  # mas upgrades re-prompt for the Apple ID on every switch.
  homebrew.casks = [
    "anki"
    "spotify"
    "tailscale-app"
    "telegram"
  ];
}
