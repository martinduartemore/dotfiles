{ config, inputs, ... }:
{
  # Taps are pinned flake inputs, so ./rebuild.sh bumping them is what moves
  # casks forward; `brew update` has nothing to pull.
  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
    autoMigrate = true;
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "fif7y/homebrew-tap" = inputs.homebrew-fif7y;
      "martinduartemore/homebrew-dotfiles" = "${../../homebrew-tap}";
    };
    trust.casks = [
      "fif7y/tap/pelmet"
      "martinduartemore/dotfiles/silico"
    ];
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "uninstall";
    };

    taps = builtins.attrNames config.nix-homebrew.taps;

    brews = [ "git-annex" ];

    casks = [
      "bitwarden"
      "discord"
      "ente-auth"
      "firefox"
      "google-chrome"
      "handy"
      "iterm2"
      "mactex"
      "ngrok"
      "obs"
      "obsidian"
      "orbstack"
      "fif7y/tap/pelmet"
      "protonvpn"
      "raycast"
      "visual-studio-code"
      "vorssaint"
      "wezterm"
      "zotero"
    ];
  };
}
