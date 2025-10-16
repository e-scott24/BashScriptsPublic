#!/bin/bash
#
## Developer: Evan Scott
## Created: 07/10/2025
## Last updated: 07/15/2025
#
# - Check for sudo/root
# - Parse through all the ssh authentication logs
# - Shows all the current and past login attempts
# -- successful and failed attempts
# - Show IP addr, the user logged in, and time for the user

# IP Address ---- User ---- Failed or Success ---- Time of login
#
# After you finish up the parsing part, write the history of the lgs into a file that can be read afterwards


sudo_check() {
    if [ "$EUID" -ne 0 ]; then
        echo "Must run as root user"
        exit 1
    fi
}


journalctl -u ssh > tempSSHLog.txt


journalctl_func() {
    echo "Successful Logins"
    echo "-----------------"
        journalctl -u ssh | while IFS="" read -r line; do
        if echo "$line" | grep -q "Accepted"; then
            username=$(echo $line | awk '/sshd/{print $4}')
            time=$(echo $line | grep "sshd" | cut -b 1-15)
            successful_login_ips=$(echo $line | awk '/Accepted/{print $11}')
            portNum=$(echo $line | awk '/Accepted/{print $13}')
            #echo -e "The username is: $username"
            #echo -e "On $time"
            #echo -e "At IP Address: $successful_login_ips"
            #echo -e "On port $portNum"
            echo -e "User \"$username\" from IP $successful_login_ips on port $portNum at $time"
            echo ""

        fi
        done
    
    
    echo "Failed Logins"
    echo "-------------"
    journalctl -u ssh | while IFS="" read -r line; do
        if echo "$line" | grep -q "Failed"; then
            username=$(echo $line | awk '/sshd/{print $4}')
            time=$(echo $line | grep "sshd" | cut -b 1-15)
            failed_login_ips=$(echo $line | awk '/Failed/{print $11}')
            portNum=$(echo $line | awk '/Failed/{print $13}')
            #echo -e "The username is: $username"
            #echo -e "On $time"
            #echo -e "At IP Address: $failed_login_ips"
            #echo -e "On port $portNum"
            echo -e "User \"$username\" from IP $failed_login_ips on port $portNum at $time"
            echo ""
        fi
        done
}



removeTempFile() {
    rm -r tempSSHLog.txt
}

run_functions() {
    sudo_check
    journalctl_func
    #removeTempFile

}

run_functions

