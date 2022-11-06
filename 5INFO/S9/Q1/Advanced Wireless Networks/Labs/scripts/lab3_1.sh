#!/bin/bash

for n in 3 4 5 6; do
	for p in 300 700 1200; do
		./waf --run "LAB3adhoc-1 --nWifi=${n} --payloadSize=${p}"
	done
done
