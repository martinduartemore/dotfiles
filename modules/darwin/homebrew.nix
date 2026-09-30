{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };

    taps = [ "fif7y/tap" ];

    brews = [ "git-annex" ];

    casks = [
      "bitwarden"
      "codexbar"
      "discord"
      "ente-auth"
      "firefox"
      "google-chrome"
      "handy"
      "iterm2"
      "linearmouse"
      "mactex"
      "ngrok"
      "obs"
      "obsidian"
      "orbstack"
      "fif7y/tap/pelmet"
      "raycast"
      "visual-studio-code"
      "vorssaint"
      "wezterm"
      "zotero"
    ];
  };
}
