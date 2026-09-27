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
      "bitwarden"
      "discord"
      "ente-auth"
      "firefox"
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
      "vorssaint"
      "wezterm"
      "zotero"
    ];
  };
}
