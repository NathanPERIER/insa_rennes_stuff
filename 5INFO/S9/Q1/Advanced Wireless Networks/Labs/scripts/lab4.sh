#!/bin/bash


function help {
	echo "usage: $0 <x> <y> <antenna> <payloadSize> <dataRate> <path>"
	exit "$1"
}


if [[ "$1" = '-h' ]]
then
	help 0
fi

if [[ $# -lt 5 ]]
then
	help 1
fi

arg_x="$1"
arg_y="$2"
arg_antenna="$3"
arg_payloadSize="$4"
arg_dataRate="$5"

path="$6/${arg_x}_${arg_y}_${arg_antenna}_${arg_payloadSize}_${arg_dataRate}"
if ! [[ -d "$path" ]]
then
	if ! mkdir -p "$path"
	then
		exit 2
	fi
fi

set -x

./waf --run "Lab4_LTE --x=${arg_x} --y=${arg_y} --antenna=${arg_antenna} --payloadSize=${arg_payloadSize} --dataRate=${arg_dataRate}Mbps"

mv *.txt *.pcap "$path"

