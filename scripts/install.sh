#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v stow >/dev/null 2>&1; then
  printf 'ERROR: GNU Stow is required. Install it first, then rerun this script.\n' >&2
  exit 1
fi

packages=(shell zsh bash git tmux)

printf 'This will run stow for: %s\n' "${packages[*]}"
printf 'Target: %s\n' "$HOME"
printf 'If existing target files are not symlinks, stow will refuse to overwrite them.\n'

for package in "${packages[@]}"; do
  stow -vt "$HOME" "$package"
done

tpm_dir="$HOME/.tmux/plugins/tpm"

if command -v tmux >/dev/null 2>&1; then
  if [[ ! -d "$tpm_dir/.git" ]]; then
    if ! command -v git >/dev/null 2>&1; then
      printf 'WARN: git is required to install TPM; skipping tmux plugin bootstrap.\n' >&2
    else
      printf 'Installing TPM to %s\n' "$tpm_dir"
      mkdir -p "$(dirname "$tpm_dir")"
      git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi
  fi

  if [[ -x "$tpm_dir/bin/install_plugins" ]]; then
    "$tpm_dir/bin/install_plugins" || \
      printf 'WARN: tmux plugin installation failed; run %s manually if needed.\n' "$tpm_dir/bin/install_plugins" >&2
  fi
else
  printf 'WARN: tmux is not installed; skipping tmux plugin bootstrap.\n' >&2
fi
