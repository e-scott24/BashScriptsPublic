#!/bin/bash
#
## Program: pingGoogle.sh
## Programmer: Evan Scott
## Last Updated: June 05, 2025
## Description: A script to ping Google (8.8.8.8). Includes the date and time of execution
#              and an if statement to determine if ping is successful/unsuccessful
#
#
#If command to tell if the ping was successful or unsuccessful
#add the date and time when file is executed
#

echo "Hello, $USER"
echo "Beginning Google ping script at $(date)"

echo ""




#pingIPAddr="8.8.8.8"
pingIPAddr="192.168.0.23"

#ping5="ping -c 5 '$pingIPAddr'"


grepUnreachable="destination host unreachable"

if (ping -c 5 $pingIPAddr | grep "$grepUnreachable"); then
    echo "Connection not found."
else
    echo "Connection successful."
fi


