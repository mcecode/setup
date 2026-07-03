# Clear screen when leaving console
if ((SHLVL == 1)) && [[ -x /usr/bin/clear_console ]]; then
	/usr/bin/clear_console --quiet
fi
