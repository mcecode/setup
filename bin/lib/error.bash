# General idea and some code taken from:
# https://gist.github.com/akostadinov/33bb2606afe1b334169dfbf202991d36
# https://github.com/olivergondza/bash-strict-mode

# ERR trap doesn't catch all errors (e.g., unbound variables), so use EXIT trap.
# See: https://unix.stackexchange.com/a/209507
trap _handle_exit EXIT
_handle_exit() {
	local -i exit_status=$?

	# Not always accurate (e.g., when an error occurs inside a command group
	# subshell)
	# -5 = Command before EXIT trap is triggered
	# -4 = LINENO and BASH_LINENO[0] reset to 1 before _handle_exit invocation
	# -3 = _handle_exit invocation
	# -2 = exit_status assignment
	# -1 = possible_error_line assignment
	local -i possible_error_line="${_COMMANDS_LINENO[-5]}"

	# Exit status doesn't guarantee that SIGINT or SIGTERM were sent, but it's a
	# good enough approximation for this use case.
	# See: https://unix.stackexchange.com/q/386836
	local -a allowed_statuses=(
		# Success
		0
		# SIGINT
		130
		# SIGTERM
		143
	)

	# The error info gathered and printed here isn't always accurate, but it gives
	# a good enough idea on where to start debugging.
	if [[ " ${allowed_statuses[*]} " != *" ${exit_status} "* ]]; then
		local -a stack
		stack+=("---")
		stack+=("Command: ${BASH_COMMAND}")
		stack+=("Status: ${exit_status}")
		stack+=("Stack trace:")

		# Start i at 1 to skip _handle_exit invocation.
		local -i i=1 stack_size=${#FUNCNAME[@]} line=$possible_error_line
		local func src
		for (( ; i < stack_size; i++)); do
			func="${FUNCNAME[$i]}"
			src="${BASH_SOURCE[$i]}"

			if ((i > 1)); then
				line="${BASH_LINENO[i - 1]}"
			fi

			stack+=("${CHARS_TAB}(${i}) ${func} ${src}:${line}")
		done

		stack+=("---")
		printf "%s\n" "${stack[@]}" >&2
	fi

	exit $exit_status
}

# EXIT trap doesn't give correct LINENO or BASH_LINENO[0], so collect all
# commands LINENO to get the error line.
# See: https://lists.gnu.org/archive/html/bug-bash/2010-09/msg00035.html
trap '_COMMANDS_LINENO+=($LINENO)' DEBUG
declare -a _COMMANDS_LINENO
