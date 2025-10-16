##Developer: Evan Scott
##Created: 07/15/2025
##Last updated: 07/17/2025

#When the script is triggered, it removes the designated file with the command
# -acts just like rm would
# -this log file should be stored in the /var/log/ folder (don't do this yet)
# -adds a note to a file, this can be called whatever you want
#In the log file, record what file was removed, who removed it, and when the file was removed





rmFile(){
    read -p "Please type the file name and path (if not in current directory) you wish to remove: " fileName
    
    rm $fileName

    rmUser=$(whoami)
    date=$(date +"%d %b, %Y")
    time=$(date +"%H:%M")
    echo "User \"$rmUser\" deleted file \"$fileName\" on $date at $time" >> removeFileLog.txt
    echo "User \"$rmUser\" deleted file \"$fileName\" on $date at $time"
    echo "To see an entire log of removed files, open file \"removeFileLog.txt\""
}





run_functions(){
    rmFile

}
run_functions
