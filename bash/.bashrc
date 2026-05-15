# ~/.bashrc: executed by bash(1) for non-login shells.

case $- in
    *i*) ;;
      *) return;;
esac

if [ -r "$HOME/.config/bash/index.bash" ]; then
    . "$HOME/.config/bash/index.bash"
fi
