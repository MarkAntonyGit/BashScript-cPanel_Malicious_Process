#################################################
#Author: Mark                                  ##
#Description: Script to find bad process users ##
#                   And Malicious Files        ##
#Version: 1.0                                  ##
#Date : 28 Feb 2021                            ##
#Version: 2.0                                  ##
#Date: 30 Mar 2021                             ##
#Version: 3.0	                               ##
#Date: 27 May 2021        		       ##
#################################################

#!/bin/bash

clear

printf  "\e[1;32m  __  __       _ _      _                   ____                               _  ___ _ _             \n"
printf  "\e[1;32m |  \/  | __ _| (_) ___(_) ___  _   _ ___  |  _ \ _ __ ___   ___ ___ ___ ___  | |/ (_| | | ___ _ __   \n"
printf  "\e[1;32m | |\/| |/ _| | | |/ __| |/ _ \| | | / __| | |_) | |__/ _ \ / __/ _ / __/ __| | | /| | | |/ _ | |__|  \n"
printf  "\e[1;32m | |  | | (_| | | | (__| | (_) | |_| \__ | |  __/| | | (_) | (_|  __\__ \__ | | . \| | | |  __| |     \n"
printf  "\e[1;32m |_|  |_|\__|_|_|_|\___|_|\___/ \__|_|___| |_|   |_|  \___/ \___\___|___|___| |_|\_|_|_|_|\___|_|     \n \n" 
printf  "\e[1;32m ----------------------------------Created By Mark Antony-------------------------------------------  \n"
printf  "\e[1;32m ---------------------------------------Version 3---------------------------------------------------  \e[1;m"
echo
#To get the usernames
ps auwx | grep -vE '^root' | grep -E '[0-9]{1,4}:[0-9]{1,2}\ (\.\/|\/tmp|\/var\/tmp|perl \/tmp|(sh\ \-c){0,1}\ \.\/[a-zA-Z0-9]*|(bash|proc)|\[stealth\])' | awk '{print $1}' | sort | uniq > /usr/local/src/Baduser.txt
procCount=`ps auwx | grep -vE '^root' | grep -E '[0-9]{1,4}:[0-9]{1,2}\ (\.\/|\/tmp|\/var\/tmp|perl \/tmp|(sh\ \-c){0,1}\ \.\/[a-zA-Z0-9]*|(bash|proc)|\[stealth\])' | awk '{print $1}' | sort | uniq | wc -l`

#/opt/zabbix_scripts/malicious.userProcs.sh > /usr/local/src/Baduser.txt
if [ ${procCount} -eq 0 ] ; then
        echo;  printf  "\e[1;34mNo Malicious Processes Found\e[1;m"; echo
else
echo > /usr/local/src/Baduserlist.txt
#For getting exact usernames and storing it to a file
for i in `cat /usr/local/src/Baduser.txt`; do ls -alh /var/cpanel/users/ | grep $i | awk '{print $9}' | cut -d\/ -f5 >> /usr/local/src/Baduserlist.txt; done
#Declaring arrays to find malicious files
declare arrayOfArraysVariant1="(\\\$[a-z0-9]{1,}\['[a-zA-Z0-9]{1,}'\]\[[0-9]{1,2}\]\\.){5,}"
declare arrayOfArraysVariant2="(\\\$[a-z0-9]{1,}\[\]\s=\s(\\\$[a-z0-9]{1,}\[[0-9]{1,}\](\.|;)){3,})"
echo; printf  "\e[1;31mMalicious Process User(s)" ; printf "\n-------------------------\e[1;m" ; echo 
cat /usr/local/src/Baduserlist.txt
echo > /usr/local/src/CWD
echo > /usr/local/src/PID
echo > /usr/local/src/DocRoots
echo > /usr/local/src/DocRootsDisk
echo > /usr/local/src/malicious_files1.txt
echo > /usr/local/src/malicious_files2.txt
#The following lines are for checking the load of the server and to abort script if load is above 5.
u=$(cat /proc/loadavg | awk {'print $1'})
Ur=$(printf "%.0f\n" $u)
echo
if [[ "$Ur" -gt 5 ]] ; then 
     printf  "\e[1;34mCurrent load is"; printf " $Ur."; printf " Reduce load below 5 and try again!\e[1;m" ; echo
else
#The following lines was used to find the exact culprit file for the malicious process. (Not needed for new version if it is a small account)
for i in `cat /usr/local/src/Baduserlist.txt`; do ps aux | grep $i | grep cron.php | awk {'print $2'} >>/usr/local/src/PID;done
for i in `cat /usr/local/src/PID`; do lsof -p $i| grep cwd | awk {'print $9'} >> /usr/local/src/CWD ; done
#The following lines are for storing the document roots inside the user(s) to a file and checking its total disk space.
for i in `cat /usr/local/src/Baduserlist.txt`; do grep $i /etc/userdatadomains | cut -d "=" -f9| sort -u | grep -v public_html/ >> /usr/local/src/DocRoots; done
for i in `cat /usr/local/src/DocRoots`; do du -sc $i | grep -v total |awk {'print $1'} >>/usr/local/src/DocRootsDisk; done
Total=$(awk '{sum= sum+$1} END {print sum/1000000}' /usr/local/src/DocRootsDisk)
TotalR=$(printf "%.0f\n" $Total)
#Creating two functions to scan the accounts according to the disk usage of accounts.
scanfull(){
#spinner to show that scan is running
printf  "\e[1;34mScanning the Account(s).....\e[1;m"
echo
while :; do
for s in / - \\ \|; do echo -ne "\r $s";sleep 1;done
done &
bgid=$!
#End spinner
for i in `cat /usr/local/src/DocRoots`;
        do 
                grep -rP $arrayOfArraysVariant1 $i | cut -d: -f1 | sort | uniq >> /usr/local/src/malicious_files1.txt; 
                for i in `cat /usr/local/src/malicious_files1.txt`;do sed -i '1s/.*/<?php/' $i ;done
        done
for i in `cat /usr/local/src/DocRoots`;
        do 
                grep -rP $arrayOfArraysVariant2 $i | cut -d: -f1 | sort | uniq >> /usr/local/src/malicious_files2.txt; 
                for i in `cat /usr/local/src/malicious_files2.txt`;do rm -f $i ; done
        done
kill -13 "$bgid"
echo; printf  "\e[1;31mMalicious Files Handled"; printf "\n-----------------------\e[1;m"
cat /usr/local/src/malicious_files1.txt /usr/local/src/malicious_files2.txt; echo
}
#function to find the culprit file for the malicious process
scanCWD(){
for i in `cat /usr/local/src/CWD`; 
	do 
		grep -rP $arrayOfArraysVariant1 $i | cut -d: -f1 | sort | uniq >> /usr/local/src/malicious_files1.txt; 
		for i in `cat /usr/local/src/malicious_files1.txt`;do sed -i '1s/.*/<?php/' $i ;done
	done
for i in `cat /usr/local/src/CWD`; 
	do 
		grep -rP $arrayOfArraysVariant2 $i | cut -d: -f1 | sort | uniq >> /usr/local/src/malicious_files2.txt; 
		for i in `cat /usr/local/src/malicious_files2.txt`;do rm -f $i ; done
	done		
echo; printf  "\e[1;31mCulprit file(s) causing the process"; printf "\n-----------------------------------\e[1;m" 
cat /usr/local/src/malicious_files1.txt /usr/local/src/malicious_files2.txt; echo
}
#get confirmation
if [[ "$TotalR" -gt 8 ]] ; then
printf '\e[1;34mTotal Disk space to scan = '$TotalR ; printf 'GB. '; read -p  $'Do you wish to scan entire account(s)?  [y|n]\e[1;m' yn
         case $yn in
         [Yy]* ) scanfull ;;
         [Nn]* ) scanCWD ;;
         *) exit;;
       esac
else
scanfull
fi
#Kill the process for the malicious user.
for i in `cat /usr/local/src/Baduserlist.txt`; do pkill -9 -u $i; done
echo; printf  "\e[1;32mAll malicious process are terminated. Do scan the user(s) for cleaning the account completely\e[1;m"; echo
fi
fi 
