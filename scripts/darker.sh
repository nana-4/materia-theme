#!/usr/bin/env bash
set -ueo pipefail
#set -x

darker_channel() {
	value="$1"
	light_delta="$2"
	result=$(bc <<< "ibase=16; $value - $light_delta")
	if [[ "$result" -lt 0 ]] ; then
		result=0
	fi
	if [[ "$result" -gt 255 ]] ; then
		result=255
	fi
	echo "$result"
}


darker() {
	hexinput=$(tr '[:lower:]' '[:upper:]' <<< "$1")
	light_delta="${2-10}"

    a="$(cut -c-2 <<< "$hexinput")"
    b="$(cut -c3-4 <<< "$hexinput")"
    c="$(cut -c5-6 <<< "$hexinput")"

	r="$(darker_channel "$a" "$light_delta")"
	g="$(darker_channel "$b" "$light_delta")"
	b="$(darker_channel "$c" "$light_delta")"

	printf '%02x%02x%02x\n' "$r" "$g" "$b"
}

darker "$@"
