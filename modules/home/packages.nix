{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curl
    htop
    watch
    wget
  ];
}
