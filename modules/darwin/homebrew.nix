{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };

    casks = [
      "alt-tab"
      "bitwarden"
      "discord"
      "ente-auth"
      "firefox"
      "font-fira-code"
      "google-chrome"
      "handy"
      "iterm2"
      "jordanbaird-ice"
      "linearmouse"
      "mactex"
      "ngrok"
      "obs"
      "obsidian"
      "orbstack"
      "raycast"
      "visual-studio-code"
      "wezterm"
    ];
  };
}
