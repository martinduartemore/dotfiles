{ pkgs, lib, ... }:
{
  # GNU coreutils/grep so `ls`/`grep` match the old ggrep/gls behaviour.
  home.packages = with pkgs; [
    coreutils
    gnugrep
  ];

  programs.zsh = {
    enable = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
      extended = true;
      ignoreAllDups = true;
      ignorePatterns = [ "ls" "cd" ];
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      ls = "ls --color=auto --group-directories-first -h";
      grep = "grep --color=auto";
      egrep = "grep -E --color=auto";
      fgrep = "grep -F --color=auto";

      ll = "ls -alhF";
      la = "ls -A";
      l = "ls -CF";

      workspace = "cd ~/workspace";
    };

    initContent = ''
      setopt HIST_REDUCE_BLANKS
      bindkey '^R' history-incremental-search-backward

      case "$TERM" in
        xterm*|rxvt*|eterm*|screen*|tmux*) print -Pn "\e]0;%n@%m: %~\a" ;;
      esac

      PROMPT='%F{green}%n@%m%f:%F{blue}%~%f'
      PROMPT+=$'\n'
      PROMPT+='λ '

      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
    '';

    # OrbStack integration (was in ~/.zprofile).
    profileExtra = ''
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :
    '';
  };

  # Replaces manual mise activation and nvm. node lives in mise: `mise use -g node@24`.
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BUN_INSTALL = "$HOME/.bun";
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    SSH_AUTH_SOCK = "/Users/martin/.bitwarden-ssh-agent.sock";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.scripts"
    "$HOME/.bun/bin"
    "$HOME/.cargo/bin" # rustup (was `. ~/.cargo/env` in ~/.zshenv)
  ];
}
