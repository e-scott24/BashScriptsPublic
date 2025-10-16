#!/bin/bash

##Developer: Evan Scott
##Created: 6/19/2025
##Last Updated: 6/19/2025


#Execute speed test
#Print date it is run
#Pull out the area or ip address where its being tested
#Pull out the download & upload speed
#If download speed is less than 40Mb
#   -echo "This network sucks, choose another network"
#Else if it is greater
#   -echo "Network is great, keep using it"

date=$(date +"%m-%d-%Y")
time=$(date +"%H:%M")

executeTest() { 
    echo "Starting speedtest at $time on $date"
    speedtest-cli --secure > temp-speedtest.txt 

}
#prints the date and time of speedtest execution
#runs the command "speedtest-cli --secure" and puts it into a temporary txt file called "temp-speedtest.txt"

executeTest


IPAddr=$(cat temp-speedtest.txt | awk -F'[()]' '/Testing from/{print $2}')
#reads the txt file, searches for text in between the parentheses ( -F [()] )
#then the /Testing from/ specific where to search for text between the parentheses
#and prints the second field/column


DownloadSpeed=$(cat temp-speedtest.txt | awk '/Download/{print $2}')
#reads the txt file, searches for "Download" and prints the second column WITHOUT the Mbit/s

DownloadSpeedMbit=$(cat temp-speedtest.txt | awk '/Download:/{print $2,$3}')
#reads the txt file, searches for "Download:" and prints the 2nd & 3rd column WITH the Mbit/s

UploadSpeed=$(cat temp-speedtest.txt | awk '/Upload/{print $2}')
#reads the txt file, searches for "Upload" and prints the second column WITHOUT the Mbit/s

UploadSpeedMbit=$(cat temp-speedtest.txt | awk '/Upload:/{print $2,$3}')
#reads the txt file, searches for "Upload:" and prints the 2nd & 3rd column WITH the Mbit/s

testVariables() { #this function is only for testing purposes and is commented out by default
    
    echo "**TESTING VARIABLES**"
    
    echo $IPAddr
    echo $DownloadSpeed
    echo $DownloadSpeedMbit
    echo $UploadSpeed
    echo $UploadSpeedMbit
}
#testVariables
#uncomment the above line if you want to see what value the variables are holding

printOutput() {
   
    echo -e "\n----------\n"

    echo "You are testing from IP Address: $IPAddr"
    echo "Download Speed: $DownloadSpeedMbit"
    echo "Upload Speed: $UploadSpeedMbit"

    echo -e "\n----------\n"

    if (( $(echo "$DownloadSpeed < 40.00" | bc -l) )); then
        echo -e "This network speed is garbage, you should choose a better network\n"
    elif (( $(echo "$DownloadSpeed > 40.00" | bc -l) )); then
        echo -e "This network speed is great, you can keep using it!\n"
    else
        echo "Something is wrong. Please try again"
    fi
}

printOutput


rm -r temp-speedtest.txt
#removes the temporary text file
