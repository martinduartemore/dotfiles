{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  repo = "${config.home.homeDirectory}/workspace/martinduartemore/dotagents";

  # Out-of-store links: Nix owns the symlink, the checkout stays mutable so
  # authoring a skill doesn't need a rebuild.
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
  agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Pinned in flake.lock and bumped daily by update-agents (modules/darwin/agents.nix).
  home.packages = [
    agents.claude-code
    agents.codex
    agents.opencode
    agents.pi
    (pkgs.callPackage ../../pkgs/claude-swap.nix { })
  ];

  home.file = {
    ".claude/skills".source = link "skills";
    ".claude/commands".source = link "prompts";
    ".claude/agents".source = link "agents";
    ".claude/CLAUDE.md".source = link "global/AGENTS.md";
    ".claude/settings.json".source = link "claude/settings.json";

    ".claude-personal/claude/settings.json".source = link "claude/settings.personal.json";

    ".codex/skills".source = link "skills";
    ".codex/prompts".source = link "prompts";
    ".codex/AGENTS.md".source = link "global/AGENTS.md";

    ".config/opencode/opencode.jsonc".source = link "opencode/opencode.jsonc";
  };

  # Dangling links fail silently at agent startup; say so at switch time.
  home.activation.checkDotagents = lib.hm.dag.entryBefore [ "linkGeneration" ] ''
    if [ ! -d ${lib.escapeShellArg repo} ]; then
      warnEcho "dotagents checkout missing at ${repo}; agent artifacts will be dangling links."
    fi
  '';
}
