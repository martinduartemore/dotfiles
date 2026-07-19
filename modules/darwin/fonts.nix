{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    source-code-pro
    fira-code
    nerd-fonts.symbols-only
  ];
}
