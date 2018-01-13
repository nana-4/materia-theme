#!/usr/bin/env bash
#set -x

darker_channel() {
	value=${1}
	light_delta=${2}
	result=$(echo "ibase=16; ${value} - ${light_delta}" | bc)
	if [[ ${result} -lt 0 ]] ; then
		result=0
	fi
	if [[ ${result} -gt 255 ]] ; then
		result=255
	fi
	echo "${result}"
}


darker() {
	hexinput=$(echo $1 | tr '[:lower:]' '[:upper:]')
	light_delta=${2-10}

    a=`echo $hexinput | cut -c-2`
    b=`echo $hexinput | cut -c3-4`
    c=`echo $hexinput | cut -c5-6`

	r=$(darker_channel ${a} ${light_delta})
	g=$(darker_channel ${b} ${light_delta})
	b=$(darker_channel ${c} ${light_delta})

	printf '%02x%02x%02x\n' ${r} ${g} ${b}
}

darker $@
