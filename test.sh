#!/bin/bash

group=$(cat liste_tous.csv | cut -d ";" -f2 | sort -u)

for j in `seq 1 4`; do
	echo $group | tr "\n" "|" | cut -d"|" -f1
done