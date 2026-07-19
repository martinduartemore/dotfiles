{ ... }:
{
  # Homebrew manages GUI casks only; CLI tooling lives in nix/mise.
  # cleanup = "none" until the formulae migration (cleanup step) is done —
  # otherwise brew would remove every formula not declared here.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
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
