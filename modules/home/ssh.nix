{ pkgs, lib, ... }:
# ~/.ssh/config is left user-managed (OrbStack/SkyPilot add order-sensitive
# includes). The Bitwarden desktop SSH agent is wired via SSH_AUTH_SOCK.
lib.mkIf pkgs.stdenv.isDarwin {
  home.sessionVariables.SSH_AUTH_SOCK = "/Users/martin/.bitwarden-ssh-agent.sock";
}
