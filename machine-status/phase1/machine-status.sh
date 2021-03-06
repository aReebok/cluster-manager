#!/bin/bash

#DISK CAPACITY : CHECK THE ROOT 
#CHECK ROOT DIRECTORY ON ITS OWN SECTION
#

#  print out date and time -----
date

#  print out NTP status    -----
timedatectl status | grep "NTP"

if [ $? = 1 ]
then
    echo --- NTP not set up
fi

#  print out hostname and ip address
echo -n "--- Hostname: ${HOSTNAME} @ ip address: "
ip ad | grep 127.0.0. | cut -d " " -f 6 | cut -d "/" -f 1 | head -n 1
# print out disk space and memory
#echo -------------------------------------------------------------------------
echo
echo ----- $'\033[1;36m'DISKS OVER CAPACITY OF 20% $'\033[0m'-----------------------------------------
df -h | head -n 1 && df -h | awk '0+$5 >= 20 {print}'

#echo -------------------------------------------------------------------------
echo
echo ----- MEMORY USAGE -------------------------------------------------------
for line in "total" "Mem:" "Swap:" "Total:"
do
    free -th | grep ${line} | cut -d " " -f -35 | tr '\n' ' ' && free -th | grep ${line} | cut -d " " -f 40-50
done

echo
echo ----- SYSTEM and FAIL2BAN ------------------------------------------------

echo -n ">>"
hostnamectl | grep "Operating System"
echo -n ">>  fail2ban: "

FILE=/etc/init.d/fail2ban
#FILE=~/machine-status.sh

if test -f "$FILE"; then
    /etc/init.d/fail2ban status | grep "active (running)\|inactive" | cut -d " " -f 5
else
    echo $'\033[0;31m'fail2ban not set up.$'\033[0m'
fi

echo
echo ----- ERROR LOGS ---------------------------------------------------------

journalctl -xe | grep "failed\|failed:\|error\|fail"
# CHECK FOR SERVICES

echo ----- END OF PROGRAM -----------------------------------------------------
