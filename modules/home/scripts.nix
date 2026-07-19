{ pkgs, ... }:
let
  scriptBin = name: pkgs.writeShellScriptBin name (builtins.readFile (../../scripts + "/${name}"));
in
{
  home.packages = map scriptBin [
    "aws-mfa.sh"
    "color_invaders.sh"
    "color_pacman.sh"
    "color_test.sh"
    "query_gpu_processes.sh"
    "update_discord.sh"
    "weather"
  ];
}
