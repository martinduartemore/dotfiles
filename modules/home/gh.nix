{ ... }:
{
  # hosts.yml holds the tokens and stays gh's own.
  programs.gh = {
    enable = true;
    # git authenticates through osxkeychain, not gh.
    gitCredentialHelper.enable = false;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      aliases.co = "pr checkout";
    };
  };
}
