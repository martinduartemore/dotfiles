{ ... }:
{
  # Determinate Nix manages the daemon and nix.conf; nix-darwin must not.
  nix.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;
  programs.zsh.enable = true;
}
