#!/usr/bin/env bash
set -ueo pipefail
#set -x

mix_channel() {
	value1="$(printf '%03d' "0x$1")"
	value2="$(printf '%03d' "0x$2")"
	ratio="$3"
	result=$(bc <<< "scale=0; ($value1 * 100 * $ratio + $value2 * 100 * (1 - $ratio))/100")
	if [[ "$result" -lt 0 ]] ; then
		result=0
	elif [[ "$result" -gt 255 ]] ; then
		result=255
	fi
	echo "$result"
}


mix() {
	hexinput1=$(tr '[:lower:]' '[:upper:]' <<< "$1")
	hexinput2=$(tr '[:lower:]' '[:upper:]' <<< "$2")
	ratio="${3-0.5}"

    a="$(cut -c-2 <<< "$hexinput1")"
    b="$(cut -c3-4 <<< "$hexinput1")"
    c="$(cut -c5-6 <<< "$hexinput1")"
    d="$(cut -c-2 <<< "$hexinput2")"
    e="$(cut -c3-4 <<< "$hexinput2")"
    f="$(cut -c5-6 <<< "$hexinput2")"

	r="$(mix_channel "$a" "$d" "$ratio")"
	g="$(mix_channel "$b" "$e" "$ratio")"
	b="$(mix_channel "$c" "$f" "$ratio")"

	printf '%02x%02x%02x\n' "$r" "$g" "$b"
}

mix "$@"
