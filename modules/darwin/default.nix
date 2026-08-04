{ lib, ... }:
{
  imports = [
    ./homebrew.nix
    ./system-defaults.nix
    ./fonts.nix
  ];

  # Determinate Nix manages the daemon and nix.conf; nix-darwin must not.
  nix.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;
  programs.zsh.enable = true;

  # Keep Homebrew on PATH for casks and cask-provided CLIs, but after the nix
  # profile dirs so nix binaries always win.
  #
  # /Library/TeX/texbin is the MacTeX cask's bin dir. Apple ships it via
  # /etc/paths.d/TeX, which only gets read by path_helper — and nix-darwin's
  # generated /etc/zprofile drops the path_helper call, so /etc/paths.d is
  # never applied. Add it explicitly instead.
  environment.systemPath = lib.mkAfter [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/Library/TeX/texbin"
  ];
}
