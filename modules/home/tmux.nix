{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = [ pkgs.tmux ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [ pkgs.xclip ];

  # Out-of-store symlink so the config stays editable (edit + prefix-r to reload).
  xdg.configFile."tmux/tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux/tmux.conf";
}
