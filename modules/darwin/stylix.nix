{ pkgs, ... }:
{
  # Tokyo Night Storm matches config/wezterm/wezterm.lua. autoEnable is off
  # because it themes every app stylix knows (blender, vencord, gtk), installed
  # or not; targets are switched on one at a time instead.
  stylix = {
    enable = true;
    autoEnable = false;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
    fonts.monospace = {
      package = pkgs.source-code-pro;
      name = "Source Code Pro";
    };
  };
}
