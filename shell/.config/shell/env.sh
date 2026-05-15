# shellcheck shell=sh
# Keep only environment variables that are safe for login and non-interactive shells.

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

if [ -d "$HOME/.local/bin" ]; then
    case ":${PATH:-}:" in
        *":$HOME/.local/bin:"*) ;;
        *) PATH="$HOME/.local/bin${PATH:+:$PATH}" ;;
    esac
fi

if [ -r "$HOME/.config/shell/local.sh" ]; then
    . "$HOME/.config/shell/local.sh"
fi

if [ -r "$HOME/.config/shell/secrets.sh" ]; then
    . "$HOME/.config/shell/secrets.sh"
fi

export PATH
