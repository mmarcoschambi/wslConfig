#!/bin/bash

lineas=$(wc -l $1 | cut -d ' ' -f1) 

for ((i=1; i<= $lineas;i++))
do
	url=$(sed -n "$i p" "$1")
	wslview $url
done

