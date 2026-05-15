# zsh 主入口：保持现有 OMZ+p10k 行为，同时把配置拆到模块。

typeset -g ZSH_CONF_DIR="${ZSH_CONF_DIR:-$HOME/.config/zsh}"

_zsh_source() {
  local file="$1"
  [[ -r "$file" ]] && source "$file"
}

_zsh_source "$ZSH_CONF_DIR/options.zsh"
_zsh_source "$ZSH_CONF_DIR/completion.zsh"
_zsh_source "$ZSH_CONF_DIR/history.zsh"
_zsh_source "$HOME/.config/shell/interactive.sh"
_zsh_source "$ZSH_CONF_DIR/omz.zsh"
_zsh_source "$ZSH_CONF_DIR/direnv.zsh"
_zsh_source "$ZSH_CONF_DIR/p10k.zsh"

unfunction _zsh_source
