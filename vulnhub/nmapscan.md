#!/bin/bash

port=$( nmap -p- $1 | grep '^[0-9]*/tcp' | cut -d'/' -f1 | tr '\n' ', ')

nmap -A -p $port $1 | tee nmap.log
