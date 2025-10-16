#!/bin/bash

##Developer: Evan Scott
##Created: 6/23/2025
##Last Updated: 6/26/2025

#The terminal will ask the user to execute the script only if you're using sudo, so you will need to
#   find a way to check for this statement
#List out the current network name, your IP Addr, and MAC Addr while you are on the network
#Then ask the user to enter a private IP Addr on the local network to locate
#   (have this to where the usre only has to put in the last digit of the IP Addr (ex: 192.168.1.xxx)
#The private IP Addr will then be pinged, if they get a destination host unavailable, the terminal will say
#   this IP is available.
#   -If not, ask the user to please input another IP Addr to see if it's available.
#Once a proper IP Addr has been selected, then the script will setup the static IP for that IP used in question
#   for the user like what you have done before.
#The script will echo back to the user the new IP they have.
#It will then give the option to the user if they would like to randomize their MAC Addr
#   If user says yes, a random MAC is generated for them for that section
#The terminal will then echo back their new IP Addr based on the network and will also echo back the
#   new MAC addr, and will exit the script


## Check for Sudo ##
sudo_check() {
if [ "$EUID" -ne 0 ]; then
    echo "Must execute as root user"
    exit 1
fi
}
sudo_check
## ^^^^^^ ##


echo "Ensure you are connected to a network"

## Grab SSID, IP Addr, & MAC Addr ##
ssid=$(iwgetid | grep -o 'ESSID:.\+' | cut -f2- -d: | tr -d '"')
currentIP=$(hostname -I)
currentMAC=$(ifconfig | grep ether | awk 'NR==1 {print $2}')

printCurrentNetInfo() {
echo -e "SSID: $ssid\nCurrent IP: $currentIP\nCurrent MAC: $currentMAC\n"

}

printCurrentNetInfo
## ^^^^^^ ##

##Preset first 3 octets of IP
presetOctets=192.168.1.


checkIP() {
## Check IP Availability ##
# -Ask user for a Private IP addr to ping (only have user input last octet 192.168.1.xxx)
# -If destination host unreachable, the IP is available
# -If ping comes back successful, choose a different IP
#askUserForIP=$(
read -p "Please enter ONLY the last octet of a private IP Address you'd like to use to see if it is available (i.e. 192.168.1.xxx): " userInputIP
#$askUserForIP

#pingIP=$(
ping -c 10 $presetOctets$userInputIP &> /dev/null ; echo $? > tempPing.txt
#$pingIP
#if [ $(cat tempPing.txt | grep "Destination Host Unreachable" 
if cat tempPing.txt | grep -q "0"; then
    echo "This IP Address is already in use. Please choose a different IP."
    checkIP
elif cat tempPing.txt | grep -q "1"; then
    echo "This IP Address is available!"
    rm -r tempPing.txt
    promptChangeIP
else
    echo "There was an error. Please try again."
    checkIP
fi

#Source for ^^ = https://stackoverflow.com/questions/18123211/checking-host-availability-by-using-ping-in-bash-scripts#:~:text=There%20is%20advanced%20version%20of%20ping%20%2D%20%22fping%22%2C%20which%20gives%20possibility%20to%20define%20the%20timeout%20in%20milliseconds

## remove tempPing.txt
#rm -r tempPing.txt

} ## closing checkIP function


promptChangeIP() {
read -p "Would you like to change your IP to the address you specified? " changeIPYesNo
case $changeIPYesNo in
    "Y" | "Yes" | "y" | "yes")
       changeIP
       ;;
    "N" | "No" | "n" | "no")
       exit 1
       ;;
    *)
       echo -e "Please input \"Y\" or \"N\""
       promptChangeIP
       ;; 
esac
}


changeIP () {
echo "Changing IP..."
gatewayaddr=$(route -n | awk '{print $2}' | sed -n '3p')

#nmcli con down $ssid
nmcli con mod $ssid ipv4.addresses $presetOctets$userInputIP/24
nmcli con mod $ssid ipv4.gateway $gatewayaddr
nmcli con mod $ssid ipv4.dns 8.8.8.8,$gatewayaddr
nmcli con mod $ssid ipv4.method manual
#nmcli dev wifi rescan
nmcli con up $ssid

newIP=$(hostname -I)

echo "Your new IP address is: $newIP" 
}


## call checkIP function
checkIP


