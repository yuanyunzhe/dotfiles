# shellcheck shell=sh
# Shared conda-family initialization.
#
# Hook output is shell-specific. Keep bash and zsh behavior consistent by
# trying mamba first, then falling back to conda.

export MAMBA_ROOT_PREFIX="${MAMBA_ROOT_PREFIX:-$HOME/miniforge3}"
export MAMBA_EXE="${MAMBA_EXE:-$MAMBA_ROOT_PREFIX/bin/mamba}"
export CONDA_EXE="${CONDA_EXE:-$MAMBA_ROOT_PREFIX/bin/conda}"

__conda_shell=""
if [ -n "${ZSH_VERSION:-}" ]; then
    __conda_shell="zsh"
elif [ -n "${BASH_VERSION:-}" ]; then
    __conda_shell="bash"
fi

if [ -n "$__conda_shell" ]; then
    __conda_loaded=0

    if [ -x "$MAMBA_EXE" ]; then
        __conda_setup="$("$MAMBA_EXE" shell hook --shell "$__conda_shell" --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
        if [ $? -eq 0 ] && [ -n "$__conda_setup" ]; then
            eval "$__conda_setup"
            __conda_loaded=1
        fi
        unset __conda_setup
    fi

    if [ "$__conda_loaded" -eq 0 ] && [ -x "$CONDA_EXE" ]; then
        __conda_setup="$("$CONDA_EXE" "shell.$__conda_shell" hook 2>/dev/null)"
        if [ $? -eq 0 ] && [ -n "$__conda_setup" ]; then
            eval "$__conda_setup"
            __conda_loaded=1
        fi
        unset __conda_setup
    fi

    if [ "$__conda_loaded" -eq 0 ]; then
        if [ -f "$MAMBA_ROOT_PREFIX/etc/profile.d/conda.sh" ]; then
            . "$MAMBA_ROOT_PREFIX/etc/profile.d/conda.sh"
        elif [ -d "$MAMBA_ROOT_PREFIX/bin" ]; then
            case ":${PATH:-}:" in
                *":$MAMBA_ROOT_PREFIX/bin:"*) ;;
                *) export PATH="$MAMBA_ROOT_PREFIX/bin${PATH:+:$PATH}" ;;
            esac
        fi

        if [ -x "$MAMBA_EXE" ]; then
            alias mamba="$MAMBA_EXE"
        fi
    fi
fi

unset __conda_shell
unset __conda_loaded
