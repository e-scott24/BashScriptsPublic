#!/bin/bash

## Programmer: Evan Scott
## Last Updated: June 10, 2025
## Description: A script to automatically grab network information


# grab the ssid of the network
# grab your ip addr
# grab the netmask/bit network
# grab the ip addr of the router (gateway)
# display back just the password of the network
# grab the mac addr of your device
# grab the interface you're using on the raspberry pi


### Grab SSID of Network ###

#ssid=$(iwgetid | grep -o 'ESSID:.\+')
#ssid=$(iwgetid | sed -n -e 's/^.*ESSID: //p')
ssid=$(iwgetid | grep -o 'ESSID:.\+' | cut -f2- -d:)

echo "The network SSID is: $ssid"




### Grab your IP Address ###
ipaddr=$(hostname -I)

echo "Your IP Address is: $ipaddr"






### Grab the Netmask and bit network ###

netmask=$(ifconfig wlan0 | awk '{print $4}' | sed -n '2p')
bitnetwork=$(ip addr show wlan0 | awk 'NR==3 {print $2}')

echo "Your netmask is $netmask"
echo "Your bit network is $bitnetwork"




### Grab the interface ###

intface=$(iwgetid | awk '{print $1}')

echo "You are using the \"$intface\" interface"




### Grab the gateway address ###

#gatewayaddr=$(route -n | awk '{print $2}')
#gatewayaddr=$(route -n | awk '{print $2}' | sed 's/^.*Gateway')
#gatewayaddr=$(route -n | sed '1d' | sed '1d' | sed '2d' |  awk '{print $2}')
gatewayaddr=$(route -n | awk '{print $2}' | sed -n '3p')
## sed -n '3p' --> prints only the 3rd line
## awk '{print $2}' --> prints only the 2nd column


echo "The gateway/router IP Address is: $gatewayaddr"






### Your MAC address ###

macaddr=$(ifconfig | grep ether | awk 'NR==1 {print $2}')

echo "Your MAC Address is: $macaddr"










##ip addr show wlan0 | awk 'NR==3 {print $2}'



#alias test='iwget'
#echo "$test"