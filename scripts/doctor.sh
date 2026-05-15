#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

warn() {
  printf 'WARN: %s\n' "$*" >&2
}

ok() {
  printf 'OK: %s\n' "$*"
}

check_command() {
  local command_name="$1"
  local hint="${2:-}"

  if command -v "$command_name" >/dev/null 2>&1; then
    ok "$command_name is installed"
  elif [[ -n "$hint" ]]; then
    warn "$command_name is not installed; $hint"
  else
    warn "$command_name is not installed"
  fi
}

check_private_file() {
  local private_file="$1"
  local label="$2"

  if [[ -e "$private_file" ]]; then
    local stat_target
    local perms

    stat_target="$(readlink -f "$private_file" 2>/dev/null || printf '%s' "$private_file")"
    perms="$(stat -c '%a' "$stat_target" 2>/dev/null || true)"
    if [[ -n "$perms" && "$perms" != "600" ]]; then
      warn "$label permissions are $perms; consider chmod 600"
    else
      ok "$label permissions look restricted"
    fi
  else
    warn "$label is missing"
  fi
}

failures=0

for path in \
  "shell/.config/shell/env.sh" \
  "shell/.config/shell/interactive.sh" \
  "shell/.config/shell/conda.sh" \
  "shell/.config/shell/local.example.sh" \
  "shell/.config/shell/secrets.example.sh" \
  "zsh/.zshrc" \
  "zsh/.config/zsh/index.zsh" \
  "bash/.bashrc" \
  "git/.gitconfig" \
  "tmux/.tmux.conf"; do
  if [[ -e "$repo_root/$path" ]]; then
    ok "found $path"
  else
    warn "missing $path"
    failures=$((failures + 1))
  fi
done

check_command stow "install GNU Stow before running scripts/install.sh"
check_command curl "install curl before running the oh-my-zsh installer"
check_command git "install git before cloning and using these dotfiles"
check_command zsh "install zsh for the primary shell workflow"
check_command tmux "install tmux for terminal session persistence"
check_command gh "install GitHub CLI for GitHub credential helper"
check_command git-lfs "install Git LFS for repositories that use LFS filters"
check_command fzf "install fzf for fuzzy search key bindings"
check_command zoxide "install zoxide for smart directory jumping"
check_command eza "install eza for enhanced ls aliases"
check_command direnv "install direnv if you use per-project environments"
check_command uv "install uv for Python project tooling"

if [[ -r "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
  ok "oh-my-zsh is installed"
else
  warn "oh-my-zsh is not installed"
fi

omz_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [[ -d "$omz_custom/themes/powerlevel10k" ]]; then
  ok "powerlevel10k theme is installed"
else
  warn "powerlevel10k theme is not installed under $omz_custom/themes"
fi

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  if [[ -d "$omz_custom/plugins/$plugin" ]]; then
    ok "$plugin plugin is installed"
  else
    warn "$plugin plugin is not installed under $omz_custom/plugins"
  fi
done

if command -v tmux >/dev/null 2>&1; then
  if [[ -r "$HOME/.tmux/plugins/tpm/tpm" ]]; then
    ok "tmux plugin manager is installed"
  else
    warn "tmux plugin manager is not installed; run scripts/install.sh"
  fi
else
  warn "tmux is not installed"
fi

for target in \
  ".zshrc" \
  ".zprofile" \
  ".p10k.zsh" \
  ".bashrc" \
  ".profile" \
  ".gitconfig" \
  ".tmux.conf"; do
  if [[ -e "$HOME/$target" && ! -L "$HOME/$target" ]]; then
    warn "$HOME/$target exists and is not a symlink; stow will not overwrite it"
  fi
done

check_private_file "$HOME/.config/shell/local.sh" "$HOME/.config/shell/local.sh"
check_private_file "$HOME/.config/shell/secrets.sh" "$HOME/.config/shell/secrets.sh"
check_private_file "$HOME/.gitconfig.local" "$HOME/.gitconfig.local"

if (( failures > 0 )); then
  exit 1
fi
