{ config, ... }:
let
  user = config.system.primaryUser;

  # Identical geometry in every window, with icons kept packed in name order.
  # A sort key is Finder's "Keep arranged by": icons reflow on every change, so
  # moving one never leaves a hole, and grid alignment comes along with it. The
  # literal "grid" (plain Snap to Grid) aligns but still places freely, which
  # is what leaves the gaps. Cost of sorting: no manual placement at all.
  iconView = {
    arrangeBy = "name";
    backgroundColorBlue = 1.0;
    backgroundColorGreen = 1.0;
    backgroundColorRed = 1.0;
    backgroundType = 0;
    gridOffsetX = 0.0;
    gridOffsetY = 0.0;
    gridSpacing = 54.0;
    iconSize = 64.0;
    labelOnBottom = true;
    showIconPreview = true;
    showItemInfo = false;
    textSize = 12.0;
    viewOptionsVersion = 1;
  };

  # Only reached in windows still pinned to list view (Recents, search results).
  # Restated here because `defaults write` replaces a dict outright instead of
  # merging, so anything omitted would be dropped on every rebuild.
  listView = {
    calculateAllSizes = false;
    iconSize = 16;
    showIconPreview = true;
    sortColumn = "name";
    textSize = 13;
    useRelativeDates = true;
    viewOptionsVersion = 1;
  };

  galleryView = {
    arrangeBy = "name";
    iconSize = 48.0;
    showIconPreview = true;
    viewOptionsVersion = 1;
  };
in
{
  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 48;
      orientation = "bottom";
      show-recents = false;
    };

    finder = {
      ShowPathbar = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "icnv";
    };

    trackpad.Clicking = true;

    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 25;
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      "com.apple.mouse.tapBehavior" = 1;
    };

    # FXPreferredViewStyle above only covers folders with no saved setting.
    # These are the "Use as Defaults" dicts behind View Options; macOS 26's
    # Finder keeps a legacy and an FK_ copy of them and reads both.
    CustomUserPreferences."com.apple.finder" = {
      StandardViewSettings = {
        SettingsType = "StandardViewSettings";
        IconViewSettings = iconView;
        ListViewSettings = listView;
        ExtendedListViewSettingsV2 = listView;
        GalleryViewSettings = galleryView;
      };

      FK_StandardViewSettings = {
        SettingsType = "FK_StandardViewSettings";
        IconViewSettings = iconView;
        ListViewSettings = listView;
        ExtendedListViewSettingsV2 = listView;
      };

      FK_DefaultIconViewSettings = iconView;
      DesktopViewSettings.IconViewSettings = iconView;

      # Groups lay items out in bands, which overrides free placement and makes
      # Snap to Grid moot. Turn them off so the grid is what actually applies.
      FXArrangeGroupViewBy = "None";
      FK_ArrangeBy = "None";
    };
  };

  # Per-folder view styles live as `vstl` records inside each parent's
  # .DS_Store and outrank every pref above. Clearing them is a one-off
  # migration, not a per-rebuild job: once cleared, the records Finder writes
  # back agree with the defaults above. Walking $HOME on every switch cost
  # seconds and found nothing, so it lives in finder-reset-views.sh instead --
  # run that after changing the view style here.
  #
  # nix-darwin restarts Dock but never Finder, and a running Finder can write
  # its cached state back over what userDefaults just wrote. SIGKILL skips that
  # flush; launchd relaunches Finder immediately. postActivation runs after
  # userDefaults, so the fresh prefs are on disk by now.
  system.activationScripts.postActivation.text = ''
    echo >&2 "restarting Finder..."
    killall -KILL -u ${user} Finder || true
  '';
}
