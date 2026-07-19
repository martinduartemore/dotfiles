{ ... }:
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
  };
}
