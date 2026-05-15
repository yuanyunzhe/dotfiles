# Enable Powerlevel10k instant prompt. This should stay close to the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_CONF_DIR="${ZSH_CONF_DIR:-$HOME/.config/zsh}"

if [[ -r "$ZSH_CONF_DIR/index.zsh" ]]; then
  source "$ZSH_CONF_DIR/index.zsh"
else
  print -u2 "zsh config not found: $ZSH_CONF_DIR/index.zsh"
fi
export PATH="$HOME/.local/bin:$PATH"
