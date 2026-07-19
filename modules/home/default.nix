{ ... }:
{
  imports = [
    ./zsh.nix
    ./git.nix
    ./packages.nix
  ];

  home.username = "martin";
  home.homeDirectory = "/Users/martin";
  programs.home-manager.enable = true;

  # Don't change after the first switch.
  home.stateVersion = "25.05";
}
