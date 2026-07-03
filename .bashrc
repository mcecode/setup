# Don't do anything if not running interactively.
if [[ "$-" != *"i"* ]]; then
	return
fi

# Options that are on or off by default are still turned on or off,
# respectively, for explicitness. Omitted options are those whose value cannot
# not be changed, are not used by interactive shells, or whose value shouldn't
# affect the way I use the shell.

# Set options
# Reference: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set +o allexport
set -o braceexpand
set +o emacs
# Off because if this is on, the Git prompt causes interactive shells to spawn
# with an error.
set +o errexit
set -o histexpand
# This is on by default and turning it on here would pollute the history with
# .bashrc contents every time an interactive shell spawns.
# set -o history
set -o ignoreeof
set +o keyword
set -o monitor
set -o noclobber
set +o noglob
set -o notify
set -o nounset
set +o onecmd
set +o physical
set +o posix
set +o privileged
set +o verbose
set -o vi
set +o xtrace

# Shell options
# Reference: https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# shopt is unlikely to return an error, hence, only the output is important.
# shellcheck disable=SC2155
export AVAILABLE_BASH_SHELL_OPTIONS=$(shopt)
shopt -s autocd
shopt -u cdable_vars
shopt -u cdspell
shopt -s cmdhist
shopt -s complete_fullquote
shopt -s direxpand
shopt -u dirspell
shopt -s dotglob
shopt -s expand_aliases
shopt -u extglob
shopt -s extquote
shopt -u failglob
shopt -u force_fignore
shopt -s globasciiranges
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"globskipdots"* ]]; then
	shopt -s globskipdots
fi
shopt -s globstar
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s hostcomplete
shopt -u huponexit
# Off since errexit is off
shopt -u inherit_errexit
shopt -s interactive_comments
shopt -u lastpipe
shopt -s lithist
shopt -u nocaseglob
shopt -u nocasematch
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"noexpand_translation"* ]]; then
	shopt -s noexpand_translation
fi
shopt -s nullglob
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"patsub_replacement"* ]]; then
	shopt -s patsub_replacement
fi
shopt -s progcomp
shopt -s progcomp_alias
shopt -s promptvars
shopt -u sourcepath
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"varredir_close"* ]]; then
	shopt -s varredir_close
fi
shopt -u xpg_echo

# Readline bindings
# References:
# https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-bind
# https://www.gnu.org/software/bash/manual/html_node/Command-Line-Editing.html
# For vi mode
bind -m vi-command Ctrl-L:clear-screen
bind -m vi-insert Ctrl-L:clear-screen

# Prompt
# References:
# https://wiki.archlinux.org/title/Bash/Prompt_customization
# https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html
# Working directory as window title
PS1="\[\033]2;\w\a\]"
# Bright bold yellow, working directory basename
PS1+="\[\033[1;93m\]\W"
# Bright bold blue, git information
git_prompt_file="$(git --exec-path 2> /dev/null)/git-sh-prompt"
if [[ -r "$git_prompt_file" ]]; then
	# ShellCheck does not need to check this.
	# shellcheck disable=SC1090
	source "$git_prompt_file"

	export GIT_PS1_SHOWDIRTYSTATE="yes"
	export GIT_PS1_SHOWUNTRACKEDFILES="yes"
	export GIT_PS1_SHOWSTASHSTATE="yes"
	export GIT_PS1_SHOWUPSTREAM="auto verbose"

	PS1+='\[\033[1;94m\]$(__git_ps1) '
fi
unset git_prompt_file
# On success exit status bright bold green else bright bold red, exit status
# shellcheck disable=SC2154
PS1+='$(s=$?; ((s == 0)) && echo "\[\033[1;92m\]${s}" || echo "\[\033[1;91m\]${s}")'
# On shell level greater than one hyphen, bright bold white, shell level, hyphen
# shellcheck disable=SC2154
PS1+='$(l=$SHLVL; ((l > 1)) && echo "-\[\033[1;97m\]${l}-")'
# Greater-than sign, reset color
PS1+="> \[\033[0m\]"

# Completions
# See: https://github.com/scop/bash-completion/blob/main/README.md#installation
if [[ ! -v BASH_COMPLETION_VERSINFO && -r "/usr/share/bash-completion/bash_completion" ]]; then
	source "/usr/share/bash-completion/bash_completion"
fi

# History
HISTCONTROL="ignoreboth:erasedups"
HISTSIZE="1000"
HISTFILESIZE="2000"
HISTTIMEFORMAT="%F %T "

# Aliases
# Catenate number
alias catn="cat --number"
# Diff auto-color
alias diff="diff --color=auto"
# Diff columns
alias difc="diff --side-by-side"
# Diff silent
alias difs="diff --brief --report-identical-files"
# Dotfiles
alias dotfiles='git --git-dir="${HOME}/.dotfiles" --work-tree="$HOME"'
# Grep auto-color
alias grep="grep --color=auto"
# List auto-color
alias ls="ls --color=auto"
# List all
alias lsa="ls --almost-all --group-directories-first --sort=version"
# List column
alias lsc="lsa --classify --format=single-column"
# List long
alias lsl="lsa --human-readable --format=long --time-style=long-iso"
# List recursive
alias lsr="lsl --recursive"
# nvidia-settings XDG
alias nvidia-settings='nvidia-settings --config="${XDG_CONFIG_HOME}/nvidia/settings"'
# Process status info
alias psi='ps --user="$USER" --format="pid,ppid,start,etime,comm" --forest'
# Process status command
alias psc='ps --user="$USER" --format="pid,args" -ww'
# Wget XDG
alias wget='wget --hsts-file="${XDG_STATE_HOME}/wget-hsts"'

# Functions
# Make directory change directory
mkdcd() {
	if [[ ! -v 1 ]]; then
		echo "Error: no directory provided" >&2
		return 1
	fi

	local dir=$1
	shift

	if [[ -v 1 ]]; then
		echo "Error: expected only one directory argument" >&2
		return 1
	fi

	if ! mkdir --parents "$dir"; then
		return 1
	fi

	cd "$dir" || return 1
}
# Make file
mkfile() {
	local path has_error="false"
	for path in "$@"; do
		if [[ "$path" == *"/" || -d "$path" ]]; then
			echo "Error: ${path} is a directory, skipping" >&2
			has_error="true"
			continue
		fi

		if [[ -e "$path" ]]; then
			local override=""

			while [[ "$override" != [YyNn] ]]; do
				read -r -p "${path} already exists, override? [Y/n] " override
			done

			if [[ "$override" == [Nn] ]]; then
				continue
			fi
		fi

		local dir="${path%"/"*}"
		if [[ "$path" == *"/"* && ! -d "$dir" ]]; then
			if ! mkdir --parents "$dir"; then
				has_error="true"
				continue
			fi
		fi

		if ! echo -n >| "$path"; then
			has_error="true"
			continue
		fi

		if [[ -v _used_by_mkbin && "$_used_by_mkbin" == "true" ]]; then
			if ! chmod u+x "$path"; then
				has_error="true"
				continue
			fi
		fi
	done

	if [[ "$has_error" == "true" ]]; then
		return 1
	fi
}
# Make binary
mkbin() {
	local _used_by_mkbin="true"
	mkfile "$@"
}
# Remove current working directory
rmcwd() {
	if [[ -v 1 ]]; then
		echo "Error: expected no arguments" >&2
		return 1
	fi

	local prev_wd="$PWD"
	cd ..
	echo "ATTENTION! ${prev_wd}"
	echo "AND ALL ITS CONTENTS WILL BE PERMANENTLY DELETED!"
	rm --recursive --interactive=once "$prev_wd"
}

# Evals
# For less
if command -v lesspipe > /dev/null 2>&1; then
	eval "$(lesspipe)"
fi
# For ls
if command -v dircolors > /dev/null 2>&1; then
	if [[ -r "${XDG_CONFIG_HOME}/dircolors" ]]; then
		eval "$(dircolors --bourne-shell "${XDG_CONFIG_HOME}/dircolors")"
	else
		eval "$(dircolors --bourne-shell)"
	fi
fi
