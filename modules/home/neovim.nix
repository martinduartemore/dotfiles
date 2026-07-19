{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
  };

  home.sessionVariables.VISUAL = "nvim";

  # Editable symlink to the repo (lazy.nvim writes lazy-lock.json). Done via an
  # activation script because a mkOutOfStoreSymlink of a whole directory trips
  # home-manager's file builder under standalone Linux.
  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ln -sfn "${config.home.homeDirectory}/dotfiles/config/nvim" "${config.home.homeDirectory}/.config/nvim"
  '';
}
