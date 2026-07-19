#!/usr/bin/env bash
# Shared helpers for bootstrap.sh and rebuild.sh. Meant to be sourced.

[[ "${BASH_SOURCE[0]}" != "${0}" ]] || {
  echo "lib.sh is meant to be sourced, not executed" >&2
  exit 1
}

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==>\033[0m %s\n' "$*" >&2; }
die() {
  printf '\033[1;31merror:\033[0m %s\n' "$*" >&2
  exit 1
}

# Absolute path of the repo (the directory containing this file).
repo_root() { cd "$(dirname "${BASH_SOURCE[0]}")" && pwd; }

detect_os() {
  case "$(uname -s)" in
    Darwin) printf 'darwin' ;;
    Linux) printf 'linux' ;;
    *) die "unsupported OS: $(uname -s)" ;;
  esac
}

# Flake attribute for a host. Arg 1: os. Arg 2: hostname (defaults to this host).
#   darwin -> "<host>"           (darwinConfigurations)
#   linux  -> "martin@<host>"    (homeConfigurations)
flake_target() {
  local os="$1" host="${2:-$(hostname -s)}"
  case "$os" in
    darwin) printf '%s' "$host" ;;
    linux) printf 'martin@%s' "$host" ;;
    *) die "unsupported os: $os" ;;
  esac
}
