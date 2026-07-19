#!/usr/bin/env bash
#
# Bootstrap a fresh machine: install Nix, then apply the config for the first time.
#
# Usage: ./bootstrap.sh [hostname]
#   hostname  Target host (default: this machine's short hostname).
#
# Nix flavor: Determinate Nix on macOS, upstream Nix on Linux.
#
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

readonly DETERMINATE_INSTALLER="https://install.determinate.systems/nix"
readonly UPSTREAM_INSTALLER="https://nixos.org/nix/install"

load_nix_profile() {
  local profile=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  # shellcheck disable=SC1090
  [[ -f "$profile" ]] && . "$profile"
}

# Upstream Nix doesn't enable flakes by default.
enable_flakes() {
  local conf="${HOME}/.config/nix/nix.conf"
  grep -qs 'experimental-features.*flakes' "$conf" && return
  mkdir -p "$(dirname "$conf")"
  echo 'experimental-features = nix-command flakes' >>"$conf"
}

install_nix() {
  local os="$1"
  # Nix may be installed but not yet on this shell's PATH (fresh install).
  load_nix_profile
  if command -v nix >/dev/null 2>&1; then
    log "Nix already installed."
    return
  fi
  case "$os" in
    darwin)
      log "Installing Determinate Nix..."
      curl --proto '=https' --tlsv1.2 -sSf -L "$DETERMINATE_INSTALLER" | sh -s -- install
      ;;
    linux)
      log "Installing upstream Nix..."
      curl --proto '=https' --tlsv1.2 -sSf -L "$UPSTREAM_INSTALLER" | sh -s -- --daemon
      enable_flakes
      ;;
  esac
  load_nix_profile
}

# First activation, before darwin-rebuild / home-manager are on PATH.
first_switch() {
  local os="$1" target="$2" flake="$3"
  case "$os" in
    darwin) sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "${flake}#${target}" ;;
    linux) nix run home-manager/master -- switch -b backup --flake "${flake}#${target}" ;;
  esac
}

main() {
  local os target flake
  os="$(detect_os)"
  target="$(flake_target "$os" "${1:-}")"
  flake="$(repo_root)"

  install_nix "$os"
  log "Bootstrapping ${target} (${os})..."
  first_switch "$os" "$target" "$flake"
  log "Done. Use ./rebuild.sh for future changes."
}

main "$@"
