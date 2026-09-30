{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Menu order. Every provider not listed here is disabled.
  providers = [
    {
      id = "claude";
      claudeSwapEnabled = true;
      claudeSwapExecutablePath = "${config.home.profileDirectory}/bin/cswap";
    }
    { id = "codex"; }
    { id = "openrouter"; }
    { id = "opencodego"; }
  ];

  declared = builtins.toJSON (map (p: p // { enabled = true; }) providers);

  # Declared fields win; apiKey, cookieHeader and tokenAccounts are the app's
  # and survive untouched because they are never declared.
  merge = ''
    ($decl | map({ (.id): . }) | add) as $d
    | ($decl | map(.id)) as $order
    | (.providers // []) as $cur
    | .version //= 1
    | .providers =
        [ $order[] as $id | ((first($cur[] | select(.id == $id))) // { id: $id }) + $d[$id] ]
        + [ $cur[] | select(.id | IN($order[]) | not) | .enabled = false ]
  '';
in
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  # config.json holds secrets and the app replaces it atomically on every
  # save, which would break a store symlink. Merge into it instead.
  home.activation.codexbarProviders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cfg="$HOME/.config/codexbar/config.json"
    if [[ ! -v DRY_RUN ]]; then
      mkdir -p -m 700 "$(dirname "$cfg")"
      touch "$cfg"
      tmp="$(mktemp "$cfg.XXXXXX")"
      # Blank means no configuration yet; malformed input still fails.
      if ${lib.getExe pkgs.jq} -n --argjson decl ${lib.escapeShellArg declared} \
          "[inputs] | (.[0] // {}) | "${lib.escapeShellArg merge} "$cfg" > "$tmp"; then
        chmod 600 "$tmp"
        mv "$tmp" "$cfg"
      else
        rm -f "$tmp"
        echo >&2 "codexbar: $cfg is not valid JSON, leaving it alone"
      fi
    fi
  '';

  # Values read off the running app, plus stacked cards so every account of a
  # provider shows at once. Left out: migration markers, window frames, the
  # selected pane and provider, reset-detector state, and iCloudSyncDeviceID.
  targets.darwin.defaults."com.steipete.codexbar" = {
    multiAccountMenuLayout = "stacked";
    refreshFrequency = "adaptive";
    backgroundWorkLowPowerModePreference = "off";
    menuBarColorPace = true;
    menuBarHidesCritters = false;
    menuBarShowsBrandIconWithPercent = false;
    quotaWarningNotificationsEnabled = true;
    quotaWarningSessionThresholds = [
      50
      20
    ];
    quotaWarningWeeklyThresholds = [
      50
      20
    ];
  };
}
