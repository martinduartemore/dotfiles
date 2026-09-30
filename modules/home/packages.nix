{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      curl
      htop
      watch
      wget

      gh
      awscli2
      terraform
      ffmpeg
      imagemagick
      just
      yq-go
      yamllint
      btop
      poppler-utils
      typst
      tex-fmt
      ansible
      fluxcd
      python3Packages.huggingface-hub

      opencode
      pi-coding-agent
      (callPackage ../../pkgs/claude-swap.nix { })
    ]
    # Homebrew's bottle on macOS: nixpkgs' darwin build fails its gpg tests.
    ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [ git-annex ];
}
