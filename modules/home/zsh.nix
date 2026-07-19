{ pkgs, ... }:
{
  home.packages = with pkgs; [
    coreutils
    gnugrep
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
      extended = true;
      ignoreAllDups = true;
      ignorePatterns = [
        "ls"
        "cd"
      ];
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

      [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
    '';

    profileExtra = ''
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :
    '';
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Shared across shells (zsh + bash).
  home.shellAliases = {
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

  home.sessionVariables = {
    BUN_INSTALL = "$HOME/.bun";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
    "$HOME/.cargo/bin"
  ];
}
