{ lib, ... }:
{
  imports = [
    ./homebrew.nix
    ./system-defaults.nix
  ];

  # Determinate Nix manages the daemon and nix.conf; nix-darwin must not.
  nix.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;
  programs.zsh.enable = true;

  # Keep Homebrew on PATH for casks and cask-provided CLIs, but after the nix
  # profile dirs so nix binaries always win.
  environment.systemPath = lib.mkAfter [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];
}
