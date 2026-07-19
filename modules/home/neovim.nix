{ pkgs, config, ... }:
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

  # Out-of-store symlink so lazy.nvim can still write lazy-lock.json back to the repo.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
}
