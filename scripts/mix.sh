#!/usr/bin/env bash
#set -x

mix_channel() {
	value1=$(printf '%03d' 0x${1})
	value2=$(printf '%03d' 0x${2})
	ratio=${3}
	result=$(echo "scale=0; (${value1} * 100 * ${ratio} + ${value2} * 100 * (1 - ${ratio}))/100" | bc)
	if [[ ${result} -lt 0 ]] ; then
		result=0
	elif [[ ${result} -gt 255 ]] ; then
		result=255
	fi
	echo "${result}"
}


mix() {
	hexinput1=$(echo $1 | tr '[:lower:]' '[:upper:]')
	hexinput2=$(echo $2 | tr '[:lower:]' '[:upper:]')
	ratio=${3-0.5}

    a=$(echo $hexinput1 | cut -c-2)
    b=$(echo $hexinput1 | cut -c3-4)
    c=$(echo $hexinput1 | cut -c5-6)
    d=$(echo $hexinput2 | cut -c-2)
    e=$(echo $hexinput2 | cut -c3-4)
    f=$(echo $hexinput2 | cut -c5-6)

	r=$(mix_channel ${a} ${d} ${ratio})
	g=$(mix_channel ${b} ${e} ${ratio})
	b=$(mix_channel ${c} ${f} ${ratio})

	printf '%02x%02x%02x\n' ${r} ${g} ${b}
}

mix $@
