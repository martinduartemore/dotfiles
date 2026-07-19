# dotfiles

My personal dotfiles. macOS is managed declaratively with [nix-darwin] + [home-manager]
via a Nix flake. Linux still uses the legacy `install.sh` symlink flow (migration in progress).

## Structure

```
flake.nix                 # inputs (nixpkgs, nix-darwin, home-manager) + outputs
hosts/
  martins-macbook-pro/    # per-machine config; imports darwin + home modules
modules/
  darwin/                 # macOS system: homebrew casks, system defaults, PATH
  home/                   # portable home-manager: zsh, git, tmux, neovim, wezterm, packages, scripts
config/nvim, config/wezterm   # editor/terminal configs (symlinked out-of-store so they stay editable)
bash/, bashrc, ...        # bash config, still used on Linux via install.sh
```

`modules/home/*` is OS-agnostic; machine-specific values live in `hosts/`. Platform-specific
bits use `pkgs.stdenv.isDarwin`.

## macOS

Nix is installed via the [Determinate] installer (Determinate Nix), so nix-darwin runs with
`nix.enable = false`. Homebrew is kept for GUI casks only; all CLI tooling lives in nix or [mise].

Bootstrap a fresh machine:

```sh
# 1. install Nix (Determinate)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. clone
git clone <repo> ~/dotfiles

# 3. first activation
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles#martins-macbook-pro
```

Apply changes after that:

```sh
sudo darwin-rebuild switch --flake ~/dotfiles
```

Validate without activating: `darwin-rebuild build --flake ~/dotfiles#martins-macbook-pro`.

### Adding config

Edit the relevant `modules/home/*.nix` and re-run `darwin-rebuild switch`:

| What | Where |
|------|-------|
| env var | `home.sessionVariables` |
| PATH entry | `home.sessionPath` |
| alias | `programs.zsh.shellAliases` |
| shell snippet | `programs.zsh.initContent` |

For quick throwaway tweaks that shouldn't be committed, drop them in `~/.zshrc.local`
(sourced automatically, no rebuild).

## Linux

Still on the legacy installer until it's migrated to home-manager:

```sh
./install.sh
```

[nix-darwin]: https://github.com/nix-darwin/nix-darwin
[home-manager]: https://github.com/nix-community/home-manager
[Determinate]: https://github.com/DeterminateSystems/nix-installer
[mise]: https://mise.jdx.dev
