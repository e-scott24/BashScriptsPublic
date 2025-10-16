#!/bin/bash


#Developer: Evan Scott
#Last Updated: 06/17/2025
#Description: A bash script to display the results of an nmap scan more clearly


# scan and pull out the gateway ip address and the bit network
## route -n
# Echo back "Beginning scan on [ip addr and bit network]"
# sudo nmap -sn <ip addr>/<bitnetwork>



## Official Instructions ##
#Tell the user they must be root to execute script
#   -If the user is not in sudo, the script exits
#Pull out the router ip addr and bit network
#Commence the scan with the command nmap -sn <routeripaddr>/<bitnetwork>
#   ex: nmap -sn 192.168.1.0/24
#
#Prints out the results into a file called file1
#Prints out from file1 the MAC, IP, and Estimated Name
#   ex: MAC ---- IP ---- Estimated Name
#
#Then will ask the suer if they would like to do a second scan on the network
#   -If yes, wait 30 seconds
#   -Commence the second scan using the same method
#   -Compare the difference between file1 and file2
#   -Shows the resutls on the terminal
#
#   -If the user puts no, the scripts exits completely
# ^^^^^^^^^^^^^^^^^^^^^^^




# Organize:
## Ip address   |   MAC Address     |   Name of Device
#================================================================
##Example: 192.168.1.1      aa:bb:cc:11:22:33       Netgear Router


### Check for SUDO ###
sudo_check() {
    if [ "$EUID" -ne 0 ] ; then
        echo "Please run as the root user"
        exit 1
    fi
}
sudo_check


### Grab gateway IP Addr ###
gatewayaddr=$(route -n | awk '{print $2}' | sed -n '3p')

#echo $gatewayaddr #testing variable

### Grab bit network
bitNetwork=$(ip addr show | grep -w inet | grep -v 127.0.0.1 | awk '{print $2}' | cut -d "/" -f 2)


## Hardcorded bit network... for now ##
#echo "Beginning scan on $gatewayaddr/24"

## NOT Hardcoded ##
#echo "Beginning scan on $gatewayaddr/$bitNetwork"



## SCAN command
#nmapScan=$(sudo nmap -sn $gatewayaddr/24)
#nmapScan1="sudo nmap -sn $gatewayaddr/24"
## SCAN without printing
#sudo nmap -sn $gatewayaddr/24 >/dev/null

## SCAN into a text file to then cat from
nmap_Scan1 () { 
    echo "Beginning scan on $gatewayaddr/$bitNetwork"
    nmap -sn $gatewayaddr/$bitNetwork > ../Desktop/BetterNmap1.txt
}
nmap_Scan1

nmap_Scan2 () {
    echo "Beginning scan on $gatewayaddr/$bitNetwork"
    nmap -sn $gatewayaddr/$bitNetwork > ../Desktop/BetterNmap2.txt
}



# ---- IP Addr ----
#IPAddr=$($scanNoPrint | grep 'Nmap scan report for')
#IPAddr=$(sudo nmap -sn $gatewayaddr/24 | grep 'Nmap scan report for')
#IPAddr=$($nmapScan1 | grep 'Nmap scan report for' | awk '{print $NF}')
IPAddr=$(cat ../Desktop/BetterNmap1.txt | grep 'Nmap scan report for' | awk '{print $NF}')
#echo $IPAddr


#echo ""


# ---- MAC Addr ----
#MACAddr=$($nmapScan1 | grep 'MAC Address:' )
#MACAddr=$(cat ../Desktop/BetterNmapScan.txt | grep 'MAC' | awk '{print $3}')
#MACAddr=$(cat ../Desktop/BetterNmapScan.txt | 
#echo $MACAddr



# ---- TEST PRINT ----
#testIP="192.1.1.1"
#testMAC="aa:bb:cc:11:22:33"
#printf "%-15s | %-15s" "$testIP" "$testMAC"
#echo ""
#cat ../Desktop/BetterNmapScan.txt | grep 'Nmap scan report for' | awk '{print $0 "\t192"}'
#cat ../Desktop/BetterNmapScan.txt | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " | "substr($0, index($0,$3)) }' | column -t
#cat ../Desktop/BetterNmapScan.txt | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " | "$3}/MAC/{print " | "$4}' | column -t
#cat ../Desktop/BetterNmapScan.txt | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{mac=substr($0, index($0,$3)); deviceName=substr($0, index($0,$4)); print " | " mac " | " deviceName }' | column -t
#cat ../Desktop/BetterNmapScan.txt | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " | "$3;}/MAC/{print " | "$4;}' | column -t
#cat ../Desktop/BetterNmapScan.txt | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " " $3;}/MAC/{print " "$4;}' | column -t
#cat ../Desktop/BetterNmapScan.txt | awk '/Nmap scan report for/{ip=$5}/MAC Address:/{mac=substr($0, index($0,$3)); device_name=substr($0, index($0,$4)); print ip " | " mac " | " device_name }' | column -t

## USING THIS ONE ###
#cat ../Desktop/BetterNmapScan.txt | awk '/Nmap scan report for/{ip=$5}/MAC Address:/{mac=$3; device_name=$4; print ip " | " mac " | " device_name }' | column -t
## ^^^ ##

#https://www.google.com/search?client=firefox-b-1-lm&channel=entpr&q=linux+output+into+different+columns+from+a+text+file+of+an+nmap+scan


# ---- PRINT OUTPUT ----
print_Output1() {
echo ""

echo "IP Address     |  MAC Address        |   Device Name"
echo "========================================================"

echo ""

#printf "%-30s | %-30s | %-30s" "$IPAddr" "$MACAddr"
cat ../Desktop/BetterNmap1.txt | awk '/Nmap scan report for/{ip=$5}/MAC Address:/{mac=$3; device_name=$4; print ip " | " mac " | " device_name }' | column -t
}


print_Output1



print_Output2() {

echo ""

echo "IP Address     |  MAC Address        |   Device Name"
echo "========================================================"

echo ""

cat ../Desktop/BetterNmap2.txt | awk '/Nmap scan report for/{ip=$5}/MAC Address:/{mac=$3; device_name=$4; print ip " | " mac " | " device_name }' | column -t
}






## ---- SECOND PART ---- ##

#readUserInput=$(read -p "Would you like to perform a second scan?" scanYesNo)
#$readUserInput
#echo $scanYesNo

#bool_UserInput="false"


compare_Scans () {
    #diff BetterNmap1.txt BetterNmap2.txt | grep "for"

    diff BetterNmap1.txt BetterNmap2.txt | awk '/Nmap scan report for/{ip=$5}/MAC Address:/{mac=$3; device_name=$4; print ip " | " mac " | " device_name }' | column -t

}


case_UserInput () {

    read -p "Would you like to perform a second scan? " scanYesNo
    case $scanYesNo in
        "Y" | "y" | "Yes" | "yes" | "YES")
            #continue
            echo "The second scan will begin in approx. 30 seconds"
            #sleep 30
            for i in {30..1}; do
                echo -ne "$i\033[0K\r"
                sleep 1
            done
            #echo "Test"
            #sudo nmap -sn $gatewayaddr/24 > ../Desktop/BetterNmap2.txt
            nmap_Scan2
            print_Output2
            compare_Scans
            ;;
        "N" | "n" | "No" | "no" | "NO")
            echo "Okay, exiting script..."
            exit 1
            #break
            ;;
        *)
            echo "Unknown input. Please type Y/N"
            case_UserInput
            #bool_UserInput="true"
            #break
            ;;
    esac

    #if [ ${prompt,,} == "y"
    #^^ the two commas ",," will convert the user input into all lowercase.
    #For example, if user types Y or YES, it will convert to y or yes
}

case_UserInput

#echo "You made it"

#if [ "$bool_UserInput" = "true" ]; then
#    #echo "TESTING"
#    $readUserInput
#    case_UserInput
#fi

#while [ "$bool_UserInput" = "false" ]; do
#    read-p "Please enter Y or N: " scanYesNo
#    case_UserInput
#done

#$caseStatement


compare_Scans () {
    #diff BetterNmap1.txt BetterNmap2.txt | grep "for"

    diff BetterNmap1 BetterNmap2.txt | awk '/Nmap scan report for/{ip=$5}/MAC Address:/{mac=$3; device_name=$4; print ip " | " mac " | " device_name }' | column -t

}




