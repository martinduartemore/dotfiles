{ pkgs, lib, ... }:
let
  # xclip is Linux/X11-only; use pbcopy on macOS.
  clip = if pkgs.stdenv.isDarwin then "pbcopy" else "xclip -selection clipboard -i";
in
{
  home.packages =
    [ pkgs.tmuxp ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [ pkgs.xclip ];

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;

    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    mouse = true;
    terminal = "screen-256color";

    extraConfig = ''
      set -g status-keys vi
      set -g display-time 2000
      set -g status on
      set -g status-interval 1

      bind-key | split-window -h -c '#{pane_current_path}'
      bind-key - split-window -v -c '#{pane_current_path}'
      bind-key c new-window -c '#{pane_current_path}'

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe '${clip}' \; send-keys -X clear-selection
      bind-key -T copy-mode-vi 'C-c' send-keys -X copy-pipe '${clip}' \; send-keys -X clear-selection
      unbind -T copy-mode-vi MouseDragEnd1Pane
      bind-key -T copy-mode-vi MouseDown1Pane select-pane \; send-keys -X clear-selection

      bind X kill-session
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded configuration file."
      bind / list-keys
    '';
  };
}
