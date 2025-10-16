#!/bin/bash

##Developer: Evan Scott
##Created: 6/19/2025
##Last Updated: 6/25/2025


#Password generator for username
#-Generate a random string of 12 characters at minimum
#-Ask user the website and username they want to use
#-Ask the user to create a username
#-Then echoes back "Generating random password"
#-Saves website, username, and password into a file that is read-write (600) only to the owner of the file
#-Encrypts the file so that a user cannot download and change the permissions



## Sudo Check ##
sudo_check() {
if [ "$EUID" -ne 0 ]; then
    echo "Must execute as root user"
    exit 1
fi
}
## ^^^^^^ ##


## Generate Random String ##
genPassword=$(openssl rand -base64 12)
## ^^^^^^ ##


## Ask user input for website & username ##
read -p "Which website are you creating an account for? " website
read -p "Please type a username: " username
## ^^^^^^ ##


## Put Website, Username, & Password into file ##
echo "Generating random password..."
echo -e "----------\nWebsite Name: $website\nUsername: $username\nPassword: $genPassword" >> passgen.txt
## ^^^^^^ ##


## Change Permissions on txt file ##
chmod 600 passgen.txt
## ^^^^^^ ##


## Tell user where to find information ##
echo -e "\nYour information can be found in the \"passgen.txt\" file, which can only be read by you for your security."