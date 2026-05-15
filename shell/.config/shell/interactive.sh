# shellcheck shell=sh
# bash/zsh 共享的交互配置入口。

if [ -r "$HOME/.config/shell/env.sh" ]; then
    . "$HOME/.config/shell/env.sh"
fi

if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

if [ -r "$HOME/.config/shell/aliases.sh" ]; then
    . "$HOME/.config/shell/aliases.sh"
fi

if [ -r "$HOME/.config/shell/nvm.sh" ]; then
    . "$HOME/.config/shell/nvm.sh"
fi

if [ -r "$HOME/.config/shell/conda.sh" ]; then
    . "$HOME/.config/shell/conda.sh"
fi
