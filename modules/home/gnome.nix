{ pkgs, lib, ... }:
lib.mkIf (!pkgs.stdenv.isDarwin) {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      accent-color = "slate";
      color-scheme = "prefer-dark";
      gtk-theme = "Yaru-sage-dark";
      icon-theme = "Yaru-sage-dark";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = 0.34188034188034178;
    };
    "org/gnome/desktop/peripherals/touchpad".two-finger-scrolling-enabled = true;

    "org/gnome/desktop/input-sources" = {
      sources = with lib.hm.gvariant; [
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "xkb"
          "us+alt-intl"
        ])
      ];
      xkb-options = [ "grp_led:scroll" ];
    };

    "org/gnome/mutter".workspaces-only-on-primary = false;

    "org/gnome/shell" = {
      enabled-extensions = [
        "ding@rastersoft.com"
        "ubuntu-dock@ubuntu.com"
        "tiling-assistant@ubuntu.com"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.wezfurlong.wezterm.desktop"
        "firefox_firefox.desktop"
      ];
    };
    "org/gnome/shell/app-switcher".current-workspace-only = true;

    "org/gnome/shell/extensions/dash-to-dock" = {
      background-opacity = 0.8;
      dash-max-icon-size = 48;
      dock-fixed = false;
      dock-position = "BOTTOM";
      extend-height = false;
      height-fraction = 0.9;
      intellihide-mode = "ALL_WINDOWS";
      isolate-workspaces = true;
      multi-monitor = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "HDMI-1";
      require-pressure-to-show = false;
      show-dock-urgent-notify = false;
    };
    "org/gnome/shell/extensions/ding" = {
      check-x11wayland = true;
      icon-size = "standard";
      show-home = false;
    };
    "org/gnome/shell/extensions/tiling-assistant" = {
      focus-hint-color = "rgb(203,67,20)";
      tiling-popup-all-workspace = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
    ];
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "wezterm";
      name = "Launch WezTerm";
    };
  };
}
