{ config, pkgs, ... }:
let
  user = config.system.primaryUser;
  repo = "${config.users.users.${user}.home}/dotfiles";

  # The CLIs themselves come from llm-agents in modules/home/agents.nix; this
  # bumps that one input and switches, so they track upstream daily.
  update-agents = pkgs.writeShellApplication {
    name = "update-agents";
    runtimeInputs = with pkgs; [
      git
      jq
    ];
    text = ''
      if [[ $EUID -ne 0 ]]; then
        exec sudo "$0" "$@"
      fi

      as_user() { sudo -u ${user} -H -- "$@"; }
      locked_rev() {
        as_user nix flake metadata --json ${repo} | jq -r '.locks.nodes."llm-agents".locked.rev'
      }

      # A switch would activate whatever is half-edited in the tree. flake.lock
      # is exempt because rebuild.sh leaves it modified as a matter of course.
      if [[ -n "$(as_user git -C ${repo} status --porcelain -- . ':!flake.lock')" ]]; then
        echo "update-agents: ${repo} has uncommitted changes, skipping" >&2
        exit 0
      fi

      before="$(locked_rev)"
      as_user nix flake update llm-agents --flake ${repo}
      if [[ "$(locked_rev)" == "$before" ]]; then
        echo "update-agents: llm-agents already at $before"
        exit 0
      fi

      darwin-rebuild switch --flake ${repo}#${config.networking.hostName}
    '';
  };
in
{
  homebrew.casks = [
    "chatgpt"
    "claude"
    "codexbar"
  ];

  environment.systemPackages = [ update-agents ];

  # A missed 05:00 (lid closed) runs on the next wake.
  launchd.daemons.update-agents.serviceConfig = {
    ProgramArguments = [ "${update-agents}/bin/update-agents" ];
    StartCalendarInterval = [
      {
        Hour = 5;
        Minute = 0;
      }
    ];
    EnvironmentVariables.PATH = "/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
    StandardOutPath = "/var/log/update-agents.log";
    StandardErrorPath = "/var/log/update-agents.log";
  };
}
