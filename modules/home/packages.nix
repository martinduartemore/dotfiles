{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      curl
      htop
      watch
      wget

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

      uv
      bun
      rustup
      cargo-watch
    ]
    # Homebrew's bottle on macOS: nixpkgs' darwin build fails its gpg tests.
    ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [ git-annex ];
}
