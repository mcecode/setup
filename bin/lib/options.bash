# Options that are on or off by default are still turned on or off,
# respectively, for explicitness. Omitted options are those whose value cannot
# be changed, are not used by non-interactive shells, or whose value shouldn't
# affect the way I write and use my scripts.

# Set options
# Reference: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set +o allexport
set -o braceexpand
set -o errexit
set -o errtrace
set -o functrace
set +o keyword
set +o monitor
set -o noclobber
set +o noexec
set +o noglob
set -o nounset
set +o onecmd
set +o physical
set -o pipefail
set +o posix
set +o privileged
set +o verbose
set +o xtrace

# Shell options
# Reference: https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"array_expand_once"* ]]; then
	shopt -s array_expand_once
else
	shopt -s assoc_expand_once
fi
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"bash_source_fullpath"* ]]; then
	shopt -s bash_source_fullpath
fi
shopt -u cdable_vars
shopt -s checkwinsize
shopt -s complete_fullquote
shopt -s direxpand
shopt -u dirspell
shopt -s dotglob
shopt -u execfail
shopt -u expand_aliases
shopt -s extdebug
shopt -u extglob
shopt -s extquote
shopt -u failglob
shopt -u force_fignore
shopt -s globasciiranges
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"globskipdots"* ]]; then
	shopt -s globskipdots
fi
shopt -s globstar
shopt -s hostcomplete
shopt -s inherit_errexit
shopt -u lastpipe
shopt -u localvar_inherit
shopt -s localvar_unset
shopt -u nocaseglob
shopt -u nocasematch
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"noexpand_translation"* ]]; then
	shopt -s noexpand_translation
fi
shopt -s nullglob
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"patsub_replacement"* ]]; then
	shopt -s patsub_replacement
fi
shopt -s shift_verbose
shopt -u sourcepath
if [[ "$AVAILABLE_BASH_SHELL_OPTIONS" == *"varredir_close"* ]]; then
	shopt -s varredir_close
fi
shopt -u xpg_echo
