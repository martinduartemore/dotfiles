{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
  ];
}
