{ config, ... }:
let
  user = config.system.primaryUser;

  # AltTab's hold shortcut: the modifier held to keep the switcher on screen,
  # paired with a press key that stays at AltTab's default of Tab, so this is
  # the Command half of Command-Tab. The stored value is an NSKeyedArchiver of
  # an SRShortcut carrying keyCode 65535 (modifier only) and modifierFlags
  # 0x100000 (Command), and "secureData" names NSSecureCoding rather than
  # anything secret.
  #
  # It cannot ride along in CustomUserPreferences: that path runs values
  # through generators.toPlist, which has no way to emit the <data> element
  # this needs. An old-style plist literal passed to defaults write does, via
  # its <hex> syntax.
  holdShortcutHex = builtins.concatStringsSep "" [
    "62706c6973743030d4010203040506070a582476657273696f6e59246172636869766572"
    "5424746f7058246f626a6563747312000186a05f100f4e534b6579656441726368697665"
    "72d1080954726f6f748001a60b0c191a1b1c55246e756c6cd60d0e0f1011121314151417"
    "185d6d6f646966696572466c6167735f101b6368617261637465727349676e6f72696e67"
    "4d6f646966696572735624636c6173735a63686172616374657273576b6579436f646557"
    "76657273696f6e800480008005800080038002513111ffff1200100000d21d1e1f205a24"
    "636c6173736e616d655824636c61737365735a535253686f7274637574a21f21584e534f"
    "626a65637400080011001a00240029003200370049004c00510053005a0060006d007b00"
    "9900a000ab00b300bb00bd00bf00c100c300c500c700c900cc00d100d600e100ea00f500"
    "f80000000000000201000000000000002200000000000000000000000000000101"
  ];

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

      # macOS has no per-Space Dock: every running app shows on every Space.
      # Dropping the pinned-but-not-running tiles is the closest thing to a
      # Dock that reflects what is actually open.
      static-only = true;
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

    # AltTab persists these as strings, not integers: writing 1 where it wants
    # "1" leaves the pref unreadable and the app falls back to its own default.
    # Values read off the running machine, backed up in alt-tab-settings.plist.
    #
    # holdShortcut is absent because its payload is an opaque secureData blob,
    # and the Sparkle keys are absent because Homebrew owns updates.
    CustomUserPreferences."com.lwouis.alt-tab-macos" = {
      spacesToShow = "1";
      screensToShow = "0";
      showHiddenWindows = "1";
      showWindowlessApps = "1";
      windowOrder = "0";
      appearanceStyle = "0";
      appearanceSize = "1";
      menubarIcon = "0";
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

    echo >&2 "alt-tab hold shortcut..."
    launchctl asuser "$(id -u -- ${user})" sudo --user=${user} -- \
      defaults write com.lwouis.alt-tab-macos holdShortcut \
      '{ secureData = <${holdShortcutHex}>; string = "\U2318"; }'
  '';
}
