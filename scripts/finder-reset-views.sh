#!/usr/bin/env bash
set -euo pipefail

# Drop Finder's saved per-folder view settings so the declared defaults in
# modules/darwin/system-defaults.nix apply everywhere again.
#
# Finder stores a folder's view style as a `vstl` record in its *parent's*
# .DS_Store, and that record outranks FXPreferredViewStyle and the
# StandardViewSettings dicts. Deleting the .DS_Store files is the only way to
# clear them; there is no pref that stops Finder writing them on local volumes.
#
# Run this after changing the default view style. It is not needed on every
# rebuild: once cleared, the records Finder writes back match the new default.
#
# Also discards icon positions, custom folder backgrounds and icons, saved
# window geometry, and per-folder sort order. ~/Desktop is left alone because
# ~/Desktop/.DS_Store is where desktop icon positions live.

usage() {
    cat <<EOF
Usage: $(basename "$0") [-n] [root...]

Delete .DS_Store files so Finder falls back to the configured default view.

  -n    Dry run -- list what would be deleted and exit.
  root  Directories to sweep (default: \$HOME).
EOF
}

dry_run=false
case "${1:-}" in
    -h | --help)
        usage
        exit 0
        ;;
    -n)
        dry_run=true
        shift
        ;;
esac

roots=("$@")
[[ ${#roots[@]} -eq 0 ]] && roots=("$HOME")

# ~/Library and the build dirs are skipped for speed; the media-library bundles
# and ~/.Trash are TCC-protected (unreadable even as root without Full Disk
# Access) and are not folders Finder browses as directories anyway.
prune=(
    -path "$HOME/Library" -o
    -path "$HOME/Desktop" -o
    -path "$HOME/.Trash" -o
    -path "$HOME/Music/Music" -o
    -path "$HOME/Movies/TV" -o
    -name '*.photoslibrary' -o
    -name 'Photo Booth Library' -o
    -name node_modules -o
    -name .git
)

# `|| true` guards the pipeline: find exits nonzero on any unreadable
# directory, and set -o pipefail would turn that into a hard failure.
# read -d '' rather than mapfile -d, which needs bash 4.4+ -- this has to work
# under Apple's bash 3.2 if run directly instead of via the nix wrapper.
found=()
while IFS= read -r -d '' path; do
    found+=("$path")
done < <(
    find "${roots[@]}" \( "${prune[@]}" \) -prune -o \
        -name .DS_Store -print0 2>/dev/null || true
)

if [[ ${#found[@]} -eq 0 ]]; then
    echo "No .DS_Store files found under ${roots[*]}."
    exit 0
fi

if [[ $dry_run == true ]]; then
    printf '%s\n' "${found[@]}"
    echo "${#found[@]} file(s) would be deleted."
    exit 0
fi

rm -f -- "${found[@]}"
echo "Deleted ${#found[@]} .DS_Store file(s)."

# Finder caches per-folder settings in memory and would write them straight
# back on quit; SIGKILL skips that flush. launchd relaunches it immediately.
killall -KILL Finder 2>/dev/null || true
echo "Restarted Finder."
