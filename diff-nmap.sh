#!/bin/bash

USER=$(whoami)
NMAP=$(which nmap)
NDIFF=$(which ndiff)
DIR=/home/$USER/nmap_diff
IP="192.168.1.0/24"
EMAIL="user@hostname"

# Check if directory is present (first run)
if [ ! -d "$DIR" ]
then
    mkdir $DIR
fi

d=$(date +%Y-%m-%d)
y=$(date -d yesterday +%Y-%m-%d)

$NMAP -oX $DIR/scan_$d.xml $IP > /dev/null 2>&1

if [ -e $DIR/scan_$y.xml ]; then
	$NDIFF $DIR/scan_$y.xml $DIR/scan_$d.xml > $DIR/diff.txt
	if [ -f "$DIR/diff.txt" ]; then
		mail -s "Nmap diff - $d" $EMAIL < $DIR/diff.txt
	fi
fi
