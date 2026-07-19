{ pkgs, lib, ... }:
let
  # xclip is Linux/X11-only; use pbcopy on macOS.
  clip = if pkgs.stdenv.isDarwin then "pbcopy" else "xclip -selection clipboard -i";
in
{
  home.packages = lib.optionals (!pkgs.stdenv.isDarwin) [ pkgs.xclip ];

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;

    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    mouse = true;
    terminal = "tmux-256color";

    extraConfig = ''
      set -sa terminal-overrides ",*:RGB"

      set -g status-keys vi
      set -g display-time 2000
      set -g status-interval 5
      set -g renumber-windows on

      # name windows after the current dir; don't let programs rename them
      setw -g allow-rename off
      setw -g automatic-rename on
      setw -g automatic-rename-format "#{b:pane_current_path}"

      # minimalist dotbar-style: transparent bg, centered windows, dim/bright contrast
      set -g status-position bottom
      set -g status-justify absolute-centre
      set -g status-style "bg=#2c313c,fg=colour8"
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left "#[fg=#{?client_prefix,colour4,colour8}] #S #[default]"
      set -g window-status-style "fg=colour8"
      set -g window-status-current-style "fg=colour7"
      set -g window-status-separator " • "
      set -g window-status-format "#W"
      set -g window-status-current-format "#W"
      set -g window-status-activity-style "fg=colour3"
      set -g status-right "#[fg=colour8]%H:%M "
      set -g pane-border-style "fg=colour8"
      set -g pane-active-border-style "fg=colour7"
      set -g message-style "bg=default,fg=colour7"
      set -g message-command-style "bg=default,fg=colour7"
      set -g mode-style "bg=colour8,fg=default"
      set -g clock-mode-colour colour4

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
