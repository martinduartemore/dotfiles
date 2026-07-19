#!/usr/bin/env bash
#
# Apply the nix configuration for a machine.
#
# Usage: ./rebuild.sh [hostname]
#   hostname  Target host (default: this machine's short hostname).
#
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

rebuild() {
  local os="$1" target="$2" flake="$3"
  case "$os" in
    darwin) sudo darwin-rebuild switch --flake "${flake}#${target}" ;;
    linux) home-manager switch -b backup --flake "${flake}#${target}" ;;
  esac
}

main() {
  local os target flake
  os="$(detect_os)"
  target="$(flake_target "$os" "${1:-}")"
  flake="$(repo_root)"

  log "Rebuilding ${target} (${os})..."
  rebuild "$os" "$target" "$flake"
  log "Done."
}

main "$@"
