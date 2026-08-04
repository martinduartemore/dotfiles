{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Neovim as a plain package — plugins are managed by lazy.nvim, and the repo
  # owns ~/.config/nvim (see linkNvimConfig below), so programs.neovim is
  # deliberately not used: it would generate its own init.lua and clobber the
  # repo file through the directory symlink on every switch.
  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  # Editable symlink to the repo (lazy.nvim writes lazy-lock.json). Done via an
  # activation script because a mkOutOfStoreSymlink of a whole directory trips
  # home-manager's file builder under standalone Linux.
  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ln -sfn "${config.home.homeDirectory}/dotfiles/config/nvim" "${config.home.homeDirectory}/.config/nvim"
  '';
}
