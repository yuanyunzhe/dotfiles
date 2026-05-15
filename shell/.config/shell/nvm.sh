# shellcheck shell=sh
# nvm supports both bash and zsh; bash completion is only loaded in bash.

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
fi

if [ -n "${BASH_VERSION:-}" ] && [ -s "$NVM_DIR/bash_completion" ]; then
    . "$NVM_DIR/bash_completion"
fi

if command -v nvm >/dev/null 2>&1; then
    nvm use node --silent
fi
