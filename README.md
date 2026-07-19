# dotfiles

My personal dotfiles, managed declaratively with [nix-darwin] + [home-manager] via a Nix flake.
macOS uses nix-darwin; non-NixOS Linux uses standalone Home Manager. Both share `modules/home/*`.

## Structure

```
flake.nix                 # inputs + outputs (darwinConfigurations, homeConfigurations, checks)
bootstrap.sh / rebuild.sh # install Nix + first switch / apply changes (auto-detect host + OS)
hosts/
  martins-macbook-pro/    # per-machine macOS config
modules/
  darwin/                 # macOS system: homebrew casks, defaults, fonts, PATH
  home/                   # portable home-manager: shells, git, tmux, neovim, wezterm,
                          #   packages, scripts, fonts, gnome (dconf), ...
config/{nvim,wezterm,tmux} # editor/terminal configs (symlinked to the repo, so they stay editable)
```

`modules/home/*` is OS-agnostic; platform-specific bits use `pkgs.stdenv.isDarwin`. macOS runs
zsh, Linux runs bash — shared aliases live in `home.shellAliases`. Nix flavor: Determinate Nix on
macOS, upstream Nix on Linux.

## Bootstrap a machine

```sh
git clone git@github.com:martinduartemore/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./bootstrap.sh          # installs Nix, runs the first switch
```

Pass a hostname to target another machine: `./bootstrap.sh <hostname>`.

## Apply changes

```sh
./rebuild.sh                             # sudo darwin-rebuild (macOS) / home-manager switch (Linux)
```

Validate without activating: `darwin-rebuild build --flake .#<host>` /
`nix build .#homeConfigurations."martin@<host>".activationPackage`.

## Adding config

Edit the relevant `modules/home/*.nix` and `./rebuild.sh`:

| What | Where |
|------|-------|
| env var | `home.sessionVariables` |
| PATH entry | `home.sessionPath` |
| alias | `home.shellAliases` |
| shell snippet | `programs.{zsh,bash}` |

For quick throwaway tweaks without a rebuild, use the scratch files:
`~/.zshrc.local`, `~/.bashrc.local`, `~/.config/tmux/local.conf`.

Formatting/lint run via a pre-commit hook (`nix develop` to install it) and in CI.

[nix-darwin]: https://github.com/nix-darwin/nix-darwin
[home-manager]: https://github.com/nix-community/home-manager
