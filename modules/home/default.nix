{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./git.nix
    ./ssh.nix
    ./packages.nix
    ./fonts.nix
    ./tmux.nix
    ./neovim.nix
    ./wezterm.nix
    ./scripts.nix
  ];

  home.username = "martin";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/martin" else "/home/martin";
  programs.home-manager.enable = true;

  # Don't change after the first switch.
  home.stateVersion = "25.05";
}
