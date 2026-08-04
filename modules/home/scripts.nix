{ pkgs, lib, ... }:
let
  scriptBin = name: pkgs.writeShellScriptBin name (builtins.readFile (../../scripts + "/${name}"));
in
{
  home.packages = map scriptBin (
    [
      "aws-mfa.sh"
      "color_invaders.sh"
      "color_pacman.sh"
      "color_test.sh"
      "query_gpu_processes.sh"
      "update_discord.sh"
      "weather"
    ]
    # Finder-only; there is nothing to reset on Linux.
    ++ lib.optionals pkgs.stdenv.isDarwin [ "finder-reset-views.sh" ]
  );
}
