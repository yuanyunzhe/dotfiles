#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

packages=(shell zsh bash git tmux)
targets=(
  ".zshrc"
  ".zprofile"
  ".p10k.zsh"
  ".bashrc"
  ".profile"
  ".gitconfig"
  ".tmux.conf"
)

usage() {
  cat <<'USAGE'
Usage: ./scripts/activate.sh [--dry-run]

Back up conflicting HOME dotfiles, then run GNU Stow for this repository.
USAGE
}

dry_run=false
if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=true
elif [[ $# -gt 0 ]]; then
  usage >&2
  exit 2
fi

if ! command -v stow >/dev/null 2>&1; then
  printf 'ERROR: GNU Stow is required. Install it first, then rerun this script.\n' >&2
  exit 1
fi

timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="$HOME/.dotfiles-backup-$timestamp"

is_repo_link() {
  local target="$1"
  [[ -L "$target" ]] || return 1

  local resolved
  resolved="$(readlink -f "$target")"
  [[ "$resolved" == "$repo_root"/* ]]
}

backup_target() {
  local rel="$1"
  local target="$HOME/$rel"
  local dest="$backup_dir/$rel"

  [[ -e "$target" || -L "$target" ]] || return 0

  if is_repo_link "$target"; then
    printf 'KEEP: %s already points into this repo\n' "$target"
    return 0
  fi

  printf 'BACKUP: %s -> %s\n' "$target" "$dest"
  if [[ "$dry_run" == false ]]; then
    mkdir -p "$(dirname "$dest")"
    mv "$target" "$dest"
  fi
}

printf 'Repo: %s\n' "$repo_root"
printf 'Target: %s\n' "$HOME"
printf 'Packages: %s\n' "${packages[*]}"

for rel in "${targets[@]}"; do
  backup_target "$rel"
done

if [[ "$dry_run" == true ]]; then
  printf 'DRY-RUN: would run stow for packages: %s\n' "${packages[*]}"
  if ! stow -nvt "$HOME" "${packages[@]}"; then
    printf 'DRY-RUN: stow reported conflicts because backup moves were not actually performed.\n' >&2
    printf 'DRY-RUN: this is expected when existing HOME files are listed above as BACKUP.\n' >&2
  fi
  exit 0
fi

stow -vt "$HOME" "${packages[@]}"

for secret_file in "$HOME/.config/shell/local.sh" "$HOME/.config/shell/secrets.sh"; do
  if [[ -e "$secret_file" ]]; then
    chmod 600 "$(readlink -f "$secret_file")"
    printf 'CHMOD: %s -> 600\n' "$secret_file"
  fi
done

printf 'Done. Backup directory: %s\n' "$backup_dir"
