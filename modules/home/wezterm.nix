{ config, ... }:
{
  # wezterm.app comes from the homebrew cask; nix only manages the config.
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/wezterm/wezterm.lua";
}
