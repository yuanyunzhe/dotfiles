# shellcheck shell=sh
# Optional TeX Live environment. Safe to source on machines without TeX Live.

_texlive_prepend_path() {
    [ -n "$1" ] || return 0
    [ -d "$1" ] || return 0
    case ":${PATH:-}:" in
        *":$1:"*) ;;
        *) PATH="$1${PATH:+:$PATH}" ;;
    esac
}

_texlive_prepend_manpath() {
    [ -n "$1" ] || return 0
    [ -d "$1" ] || return 0
    case ":${MANPATH:-}:" in
        *":$1:"*) ;;
        *) MANPATH="$1${MANPATH:+:$MANPATH}" ;;
    esac
}

_texlive_prepend_infopath() {
    [ -n "$1" ] || return 0
    [ -d "$1" ] || return 0
    case ":${INFOPATH:-}:" in
        *":$1:"*) ;;
        *) INFOPATH="$1${INFOPATH:+:$INFOPATH}" ;;
    esac
}

_texlive_cleanup() {
    unset _texlive_year
    unset _texlive_root
    unset _texlive_arch
    unset _texlive_bin
    unset _texlive_manpath
    unset _texlive_infopath
    unset -f _texlive_prepend_path
    unset -f _texlive_prepend_manpath
    unset -f _texlive_prepend_infopath
    unset -f _texlive_cleanup
}

_texlive_year="${TEXLIVE_YEAR:-2025}"
_texlive_root="${TEXLIVE_ROOT:-/usr/local/texlive/$_texlive_year}"
_texlive_arch="${TEXLIVE_ARCH:-x86_64-linux}"
_texlive_bin="${TEXLIVE_BIN:-$_texlive_root/bin/$_texlive_arch}"
_texlive_manpath="${TEXLIVE_MANPATH:-$_texlive_root/texmf-dist/doc/man}"
_texlive_infopath="${TEXLIVE_INFOPATH:-$_texlive_root/texmf-dist/doc/info}"

if [ ! -d "$_texlive_bin" ]; then
    _texlive_cleanup
    return 0
fi

_texlive_prepend_path "$_texlive_bin"
_texlive_prepend_manpath "$_texlive_manpath"
_texlive_prepend_infopath "$_texlive_infopath"

export TEXLIVE_YEAR="$_texlive_year"
export TEXLIVE_ROOT="$_texlive_root"
export TEXLIVE_ARCH="$_texlive_arch"
export PATH
export MANPATH
export INFOPATH

_texlive_cleanup
