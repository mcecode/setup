# umask
umask 0077

# Editor
export EDITOR="nvim"

# XDG
# References:
# https://github.com/b3nj5m1n/xdg-ninja
# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="${HOME}/.config"
export ASPELL_CONF="per-conf ${XDG_CONFIG_HOME}/aspell/aspell.conf; personal ${XDG_CONFIG_HOME}/aspell/en.pws; repl ${XDG_CONFIG_HOME}/aspell/en.prepl"
export PARALLEL_HOME="${XDG_CONFIG_HOME}/parallel"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc.py"

export XDG_CACHE_HOME="${HOME}/.cache"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"

export XDG_DATA_HOME="${HOME}/.local/share"
export DOTNET_CLI_HOME="${XDG_DATA_HOME}/dotnet"

export XDG_STATE_HOME="${HOME}/.local/state"
export HISTFILE="${XDG_STATE_HOME}/bash/history"
if ! [ -f "$HISTFILE" ]; then
	mkdir --parents "$(dirname "$HISTFILE")"
	touch "$HISTFILE"
fi
export LESSHISTFILE="${XDG_STATE_HOME}/lesshst"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"

# Custom directories
export HOME_BIN="${HOME}/bin"
export HOME_LOCAL_BIN="${HOME}/.local/bin"

# PATH
# Shareable executables
if [ -d "$HOME_BIN" ]; then
	export PATH="${HOME_BIN}:${PATH}"
fi
# Local executables
if [ -d "$HOME_LOCAL_BIN" ]; then
	export PATH="${HOME_LOCAL_BIN}:${PATH}"
fi
# Local shims created by Deven
if [ -d "${HOME_LOCAL_BIN}/shims" ]; then
	export PATH="${HOME_LOCAL_BIN}/shims:${PATH}"
fi

# Bash config
if [ -n "$BASH_VERSION" ] && [ -r "${HOME}/.bashrc" ]; then
	. "${HOME}/.bashrc"
fi

# Deven
deven up
