{ ... }:
{
  programs.git = {
    enable = true;

    ignores = [ "**/.claude/settings.local.json" ];

    settings = {
      user = {
        name = "Martin Duarte More";
        email = "martinduartemore@gmail.com";
      };

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      fetch.prune = true;
      rebase.autoStash = true;
      diff.colorMoved = "default";
      merge.conflictStyle = "zdiff3";
      rerere.enabled = true;
      column.ui = "auto";
      branch.sort = "-committerdate";
    };
  };
}
