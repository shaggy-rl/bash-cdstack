# cd Stack management
#
# You `cd` around like you normally would, and the directories are pushed
# into a stack.  Use the function `s` to view the stack of directories,
# and run `cs $num` to `cd` into the directory listed.
#
# inspired by http://www.derekwyatt.org/2011/08/18/my-bash-directory-management/
#
# Author: Dave Eddy <dave@daveeddy.com>
# License: MIT

_CD_STACK=()
CD_STACK_MAX=${CD_STACK_MAX:-15}
cd() {
	local oPWD=$PWD
	builtin cd "$@" || return $?
	_CD_STACK=("$oPWD" "${_CD_STACK[@]}")
	if (( ${#_CD_STACK[@]} > CD_STACK_MAX )); then
		unset _CD_STACK[${#_CD_STACK[@]}-1]
	fi
}
s() {
	local i=$(( ${#_CD_STACK[@]} - 1 ))
	for (( ; i >= 0; i-- )); do
		printf '%2d: %s\n' "$i" "${_CD_STACK[$i]/#$HOME/~}"
	done
}
cs() {
	cd "${_CD_STACK[$1]}"
}
