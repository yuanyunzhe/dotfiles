# dotfiles

Personal Linux dotfiles for a zsh-first workflow.

This repository is intentionally conservative: the first version migrates the
current working configuration into a Stow-friendly layout without changing the
active files in `$HOME`.

## Layout

```text
bash/      Bash entry files and bash-specific initialization
git/       Git configuration
shell/     Shared shell environment, aliases, and tool bootstrap
scripts/   Install and diagnostic helpers
tmux/      tmux configuration
zsh/       zsh + oh-my-zsh + Powerlevel10k configuration
```

## New Machine Bootstrap

Start with the smallest required set:

```text
git stow zsh tmux curl
```

Everything else is an enhancement checked by `./scripts/doctor.sh`.

### With Sudo

On Ubuntu/Debian:

```bash
sudo apt-get update
sudo apt-get install -y curl git stow zsh tmux git-lfs fzf direnv
sudo apt-get install -y gh zoxide eza
```

If `gh`, `zoxide`, or `eza` is not available in your distribution repository,
skip it for now and rerun `./scripts/doctor.sh` after installing the rest.

### Without Sudo

If you do not have sudo, use a user-level package manager when available:

```bash
mamba install -c conda-forge gh git-lfs fzf zoxide eza direnv
```

or:

```bash
conda install -c conda-forge gh git-lfs fzf zoxide eza direnv
```

If neither sudo nor conda/mamba is available, continue with the required pieces
below and let `./scripts/doctor.sh` report the remaining optional tools.

Install `uv` with the official standalone installer:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Install oh-my-zsh and the Powerlevel10k theme before opening a zsh session with
this configuration:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

Clone this repository, then run the diagnostic check:

```bash
./scripts/doctor.sh
```

Create machine-local files before or after activation:

```bash
cp shell/.config/shell/local.example.sh ~/.config/shell/local.sh
cp shell/.config/shell/secrets.example.sh ~/.config/shell/secrets.sh
chmod 600 ~/.config/shell/local.sh ~/.config/shell/secrets.sh
```

Create `~/.gitconfig.local` for Git identity. This file is intentionally kept
outside the repository:

```ini
[user]
    name = Your Name
    email = you@example.com
```

```bash
chmod 600 ~/.gitconfig.local
```

Activate the dotfiles:

```bash
./scripts/activate.sh
```

The activation script backs up conflicting files in `$HOME` before running
Stow. The backup directory is printed during the run.

For a direct Stow run without backup handling:

```bash
./scripts/install.sh
```

`scripts/install.sh` also bootstraps TPM and installs the tmux plugins declared
in `.tmux.conf`.

After activation, open a new shell or run:

```bash
source ~/.zshrc
```

Then rerun:

```bash
./scripts/doctor.sh
```

## Packages

This repository uses GNU Stow to link files into `$HOME`. There is no `stow/`
package in this repo; `.stowrc` is only local configuration for commands run
from the repository root.

On a new machine, prefer:

```bash
./scripts/activate.sh
```

It backs up existing files such as `~/.zshrc` and `~/.bashrc` before running
Stow. Use direct `stow` commands only when the target files do not exist or are
already symlinks owned by this repository.

```bash
stow shell
stow zsh
stow bash
stow git
stow tmux
```

## Private Config

Do not commit secrets or machine-only paths. Keep shared defaults in tracked
files and put machine-local overrides in ignored local files, for example:

```text
~/.config/shell/local.sh
~/.config/shell/secrets.sh
~/.gitconfig.local
~/.bashrc.local
```

Use `shell/.config/shell/local.example.sh` as the template for
`shell/.config/shell/local.sh`. The real `local.sh` is ignored by git.
Use `shell/.config/shell/secrets.example.sh` as the template for
`shell/.config/shell/secrets.sh`. The real `secrets.sh` is ignored by git.

Tracked Git configuration includes common behavior and the GitHub credential
helper. Personal identity belongs in `~/.gitconfig.local`, which is included by
`git/.gitconfig` but must not be committed.
