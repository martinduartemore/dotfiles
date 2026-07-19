{ pkgs, lib, ... }:
# macOS fonts are managed at the system level (modules/darwin/fonts.nix).
# On Linux, install them into the user profile and let fontconfig pick them up.
lib.mkIf (!pkgs.stdenv.isDarwin) {
  home.packages = with pkgs; [
    source-code-pro
    fira-code
    nerd-fonts.symbols-only
  ];
  fonts.fontconfig.enable = true;
}
