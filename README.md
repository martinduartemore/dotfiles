# dotfiles

Personal dotfiles managed declaratively with a Nix flake — [nix-darwin] on macOS and standalone
[home-manager] on non-NixOS Linux. Both share the portable modules in `modules/home/`.

## Machines

| Host | OS | Flake attribute |
|------|----|-----------------|
| `martins-macbook-pro` | macOS (Apple Silicon) | `darwinConfigurations."martins-macbook-pro"` |
| `martin-desktop` | Ubuntu (x86_64) | `homeConfigurations."martin@martin-desktop"` |

macOS runs **zsh**, Linux runs **bash**; shared aliases/vars live in `home.shellAliases` /
`home.sessionVariables`. Nix flavor: **Determinate Nix** on macOS, **upstream Nix** on Linux.

## Structure

```
flake.nix                    # inputs + outputs (darwin/home configs, formatter, checks, devShells)
bootstrap.sh                 # fresh machine: install Nix + first switch
rebuild.sh                   # apply changes (auto-detects host + OS)
lib.sh                       # shared helpers for the two scripts
hosts/
  martins-macbook-pro/       # macOS host (nix-darwin system)
  martin-desktop/            # Linux host (home-manager)
modules/
  darwin/                    # macOS system: homebrew casks, defaults, fonts, PATH
  home/                      # portable home-manager modules (see below)
config/{nvim,wezterm,tmux}   # editor/terminal configs, symlinked to the repo so they stay editable
bash/{prompt,functions}      # bash fragments read into the generated ~/.bashrc
```

`modules/home/` covers: `zsh`, `bash`, `git`, `ssh`, `tmux`, `neovim`, `wezterm`, `packages`,
`scripts`, `fonts`, `gnome` (Linux dconf). Platform-specific bits are guarded with
`pkgs.stdenv.isDarwin`.

## Bootstrap a fresh machine

```sh
git clone git@github.com:martinduartemore/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./bootstrap.sh
```

Installs Nix (Determinate on macOS, upstream + flakes on Linux) and runs the first switch for the
current host. Target another machine with `./bootstrap.sh <hostname>`.

## Apply changes

```sh
./rebuild.sh                 # sudo darwin-rebuild switch (macOS) | home-manager switch (Linux)
```

Validate without activating:

```sh
darwin-rebuild build --flake .#martins-macbook-pro
nix build '.#homeConfigurations."martin@martin-desktop".activationPackage'
```

## Adding config

Edit the relevant `modules/home/*.nix`, then `./rebuild.sh`:

| What | Where |
|------|-------|
| env var | `home.sessionVariables` |
| PATH entry | `home.sessionPath` |
| shell alias | `home.shellAliases` |
| shell snippet | `programs.zsh` / `programs.bash` |
| package | `modules/home/packages.nix` |

The `config/{nvim,wezterm,tmux}` files are symlinked to the working tree, so editing them takes
effect immediately (reload the app / `prefix-r`) — no rebuild. For quick throwaway shell/tmux
tweaks, use the scratch files, which are sourced if present:
`~/.zshrc.local`, `~/.bashrc.local`, `~/.config/tmux/local.conf`.

## Platform notes

- **macOS** — GUI apps are Homebrew casks (managed by nix-darwin's `homebrew` module); all CLI
  tooling is nix or [mise]. System settings (dock, finder, keyboard) live in
  `modules/darwin/system-defaults.nix`.
- **Linux** — bash login shell, Wayland clipboard (`wl-copy`), GNOME settings via dconf. System
  packages (`build-essential`, `clang`, drivers, …) are **not** nix-managed on non-NixOS — install
  those with `apt`.
- **Agent CLIs** (claude, codex, opencode, pi) are managed outside nix (native installer / mise) so
  they can update daily.

## Quality

Formatting ([treefmt] + nixfmt) and linting (statix, deadnix, shellcheck) run as a pre-commit hook
and in GitHub Actions CI. Install the hook locally with `nix develop`. Format everything with
`nix fmt`.

[nix-darwin]: https://github.com/nix-darwin/nix-darwin
[home-manager]: https://github.com/nix-community/home-manager
[mise]: https://mise.jdx.dev
[treefmt]: https://github.com/numtide/treefmt-nix
