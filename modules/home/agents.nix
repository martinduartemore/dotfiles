{ config, lib, ... }:
let
  repo = "${config.home.homeDirectory}/workspace/martinduartemore/dotagents";

  # Out-of-store links: Nix owns the symlink, the checkout stays mutable so
  # authoring a skill doesn't need a rebuild.
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
in
{
  home.file = {
    ".claude/skills".source = link "skills";
    ".claude/commands".source = link "prompts";
    ".claude/agents".source = link "agents";
    ".claude/CLAUDE.md".source = link "AGENTS.md";
    ".claude/settings.json".source = link "claude/settings.json";

    ".codex/skills".source = link "skills";
    ".codex/prompts".source = link "prompts";
    ".codex/AGENTS.md".source = link "AGENTS.md";
  };

  # Dangling links fail silently at agent startup; say so at switch time.
  home.activation.checkDotagents = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
    if [ ! -d ${lib.escapeShellArg repo} ]; then
      warnEcho "dotagents checkout missing at ${repo}; agent artifacts will be dangling links."
    fi
  '';
}
