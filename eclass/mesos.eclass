# Copyright 1999-2021 adjust GmbH
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: mesos.eclass
# @MAINTAINER:
# ops@adjust.com
# @BLURB: A set of shell functions for switching back and forth between gcc versions.

if [[ -z ${_MESOS_ECLASS} ]]; then
_MESOS_ECLASS_=1

# @FUNCTION: get-current-gcc-version
# @DESCRIPTION:
# Get the current gcc version from the gcc-config -l command output.
get-current-gcc-version() {
	local IFS=$'\n'
	local line num
	for line in $(gcc-config -l); do
		# Delete all beginning whitespaces.
		line=$(sed -e 's/^[ \t]*//g;' <<< $line)
		# If the line contains a star.
		if [[ $line =~ \* ]]; then
			# Delete the [ and ] characters.
			line=$(sed -e 's/\[//g; s/\]//g;' <<< $line)
			# Some Python-fu to extract the gcc-config compiler number.
			num=$(python -c "import sys; print(sys.stdin.read().strip().split(' ')[0])" <<< $line)
			echo $num
			break
		fi
	done
}

# @FUNCTION: switch-to-gcc-9
# @DESCRIPTION:
# Switch to gcc v9 (Mesos doesn't compile with gcc version >= 10).
switch-to-gcc-9() {
	local IFS=$'\n'
	local line num
	for line in $(gcc-config -l); do
		line=$(sed -e 's/^[ \t]*//g;' <<< $line)
		# We're only interested in gcc v9 (whatever version works for compiling Mesos).
		if [[ $line =~ ^.*-gnu-9.*$ ]]; then
			line=$(sed -e 's/\[//g; s/\]//g;' <<< $line)
			num=$(python -c "import sys; print(sys.stdin.read().strip().split(' ')[0])" <<< $line)
			# Set the compiler.
			gcc-config $num
		fi
	done
}

fi
