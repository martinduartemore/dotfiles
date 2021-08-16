#!/usr/bin/env bash
# Base16 Ocean - Gnome Terminal color scheme install script

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Base 16 Ocean"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="base-16-ocean"
[[ -z "$DCONF" ]] && DCONF=dconf
[[ -z "$UUIDGEN" ]] && UUIDGEN=uuidgen

dset() {
    local key="$1"; shift
    local val="$1"; shift

    if [[ "$type" == "string" ]]; then
        val="'$val'"
    fi

    "$DCONF" write "$PROFILE_KEY/$key" "$val"
}

# Because dconf still doesn't have "append"
dlist_append() {
    local key="$1"; shift
    local val="$1"; shift

    local entries="$(
        {
            "$DCONF" read "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
            echo "'$val'"
        } | head -c-1 | tr "\n" ,
    )"

    "$DCONF" write "$key" "[$entries]"
}

# Check that uuidgen is available
type $UUIDGEN >/dev/null 2>&1 || { echo >&2 "Requires uuidgen but it's not installed.  Aborting!"; exit 1; }

[[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW=/org/gnome/terminal/legacy/profiles:

if [[ -n "`$DCONF list $BASE_KEY_NEW/`" ]]; then
    if which "$UUIDGEN" > /dev/null 2>&1; then
        PROFILE_SLUG=`uuidgen`
    fi

    if [[ -n "`$DCONF read $BASE_KEY_NEW/default`" ]]; then
        DEFAULT_SLUG=`$DCONF read $BASE_KEY_NEW/default | tr -d \'`
    else
        DEFAULT_SLUG=`$DCONF list $BASE_KEY_NEW/ | grep '^:' | head -n1 | tr -d :/`
    fi

    DEFAULT_KEY="$BASE_KEY_NEW/:$DEFAULT_SLUG"
    PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"

    # Copy existing settings from default profile
    $DCONF dump "$DEFAULT_KEY/" | $DCONF load "$PROFILE_KEY/"

    # Add new copy to list of profiles
    dlist_append $BASE_KEY_NEW/list "$PROFILE_SLUG"

    # Update profile values with theme options
    dset visible-name "'$PROFILE_NAME'"
    dset palette "['#2b303b', '#bf616a', '#a3be8c', '#ebcb8b', '#8fa1b3', '#b48ead', '#96b5b4', '#c0c5ce', '#65737e', '#d08770', '#343d46', '#4f5b66', '#a7adba', '#dfe1e8', '#ab7967', '#eff1f5']"
    dset background-color "'#2b303b'"
    dset foreground-color "'#c0c5ce'"
    dset bold-color "'#c0c5ce'"
    dset bold-color-same-as-fg "true"
    dset cursor-colors-set "true"
    dset cursor-background-color "'#c0c5ce'"
    dset cursor-foreground-color "'#2b303b'"
    dset use-theme-colors "false"
    dset use-theme-background "false"

    unset PROFILE_NAME
    unset PROFILE_SLUG
    unset DCONF
    unset UUIDGEN
    exit 0
fi
