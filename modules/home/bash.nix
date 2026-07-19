{ pkgs, lib, ... }:
# bash is the login shell on Linux; on macOS zsh is used instead.
lib.mkIf (!pkgs.stdenv.isDarwin) {
  programs.bash = {
    enable = true;

    historySize = 10000;
    historyFileSize = 10000;
    historyControl = [ "ignoreboth" ];
    historyIgnore = [
      "ls"
      "cd"
    ];

    shellOptions = [
      "autocd"
      "cdspell"
      "checkwinsize"
      "cmdhist"
      "extglob"
      "globstar"
      "histappend"
      "histreedit"
    ];

    # Prompt and functions are read verbatim from bash/ (avoids escaping their
    # ${...} in a nix string, and keeps those files editable).
    initExtra = ''
      export HISTTIMEFORMAT='(%F %T) '

      ${builtins.readFile ../../bash/prompt}
      ${builtins.readFile ../../bash/functions}

      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
      [ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
    '';
  };
}
