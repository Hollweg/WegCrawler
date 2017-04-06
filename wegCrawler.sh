#!/bin/bash

echo " "
echo "####   Simple web-crawler developed to gather target information  ####"
echo "####               Developed for Riscure Wargames   		        ####" 
echo "####                  by Guilherme Hollweg v0.1                   ####"
echo " "

echo "        WegCrawler started on `date`"
echo " "

domain=0
dirPath="/home/wegCrawler"
fileName=""
scanType=""
testDomain=""

echo "Type the target domain:"
echo "ex.: www.4linux.com.br or 54.45.213.215"
echo " "
read domain

echo "Checking Domain..."
ping -c 3 $domain 2> temp.txt
testDomain=`tail -n1 temp.txt | rev | cut -f1 -d' ' | rev`

if [ "$testDomain" == "known" ];
then
    echo " "
    echo "Invalid domain or no network. Exiting..."
    rm -f ./temp.txt
    exit
else
   echo " "
   echo "Domain OK!"
fi 

echo " "
echo "The result file will be stored on $dirPath/"

echo "Checking for the existence of folder /wegCrawler/ ..."
cd /home/

if [ -d "$dirPath/" ]; 
then	
    echo "The folder exists."
else	
    echo "The folder is being created..."
    mkdir wegCrawler
    echo "Done."
fi

fileName="wegCrawler-$domain-`date`.log"
echo " "
echo "The information will be stored on /home/wegCrawler/$fileName"
echo " "

echo "Do you want a full scan? (y/n)"
read scanType

echo " "
echo "OK! The scan can last a few minutes... "
echo "####   Simple web-crawler developed to gather target information  ####" >> "$dirPath"/"$fileName"
echo "####               Developed for Riscure Wargames   		        ####" >> "$dirPath"/"$fileName"
echo "####                 by Guilherme Hollweg v0.1                    ####" >> "$dirPath"/"$fileName"
echo " " >> "$dirPath"/"$fileName"
echo "Target: $domain" >> "$dirPath"/"$fileName"

echo " "
echo "Gathering information about $domain register... "
echo "Gathering information about $domain register... " >> "$dirPath"/"$fileName"
whois $domain >> "$dirPath"/"$fileName"
echo " " >> "$dirPath"/"$fileName"
echo "###########################" >> "$dirPath"/"$fileName"

echo "Digging... "
echo "Digging... " >> "$dirPath"/"$fileName"
dig $domain >> "$dirPath"/"$fileName"
echo " " >> "$dirPath"/"$fileName"
echo "###########################" >> "$dirPath"/"$fileName"

echo " " >> "$dirPath"/"$fileName"
echo "Trying to find domain host detailed information... "
echo "Trying to find domain host detailed information... " >> "$dirPath"/"$fileName"
echo " " >> "$dirPath"/"$fileName"
host -v -t NS $domain >> "$dirPath"/"$fileName"
echo " " >> "$dirPath"/"$fileName"
echo "###########################" >> "$dirPath"/"$fileName"

if [ "$scanType" == "y" ] || [ $scanType == "yes" ];
then
	echo " " >> "$dirPath"/"$fileName"
	echo "Checking for domain file structure... "
	echo "Checking for domain file structure... " >> "$dirPath"/"$fileName"
	dirb http://$domain /usr/share/dirb/wordlists/small.txt >> "$dirPath"/"$fileName"
	echo " " >> "$dirPath"/"$fileName"
	echo "###########################" >> "$dirPath"/"$fileName"

	echo " " >> "$dirPath"/"$fileName"
	echo "Performing DNS analysis... "
	echo "Performing DNS analysis... " >> "$dirPath"/"$fileName"
	dnsenum --noreverse $domain >> "$dirPath"/"$fileName"
	echo " " >> "$dirPath"/"$fileName"
	dnsmap $domain -w /usr/share/wordlists/dnsmap.txt >> "$dirPath"/"$fileName"
	echo " " >> "$dirPath"/"$fileName"
	echo "###########################" >> "$dirPath"/"$fileName"

	echo " " >> "$dirPath"/"$fileName"
	echo "Performing NMAP analysis... "
	echo "Performing NMAP analysis... " >> "$dirPath"/"$fileName"
	nmap -sS -O $domain >> "$dirPath"/"$fileName"
	echo " " >> "$dirPath"/"$fileName"
	nmap -Pn $domain >> "$dirPath"/"$fileName"
	echo " " >> "$dirPath"/"$fileName"
	nmap -Pn $domain -p 20,21,22,23,25,80,107,115,546,547,666,992,31337 >> "$dirPath"/"$fileName"
	echo " " >> "$dirPath"/"$fileName"
	echo "###########################" >> "$dirPath"/"$fileName"

else
	echo " " >> "$dirPath"/"$fileName"
	echo "Performing NMAP analysis... "
	echo "Performing NMAP analysis... " >> "$dirPath"/"$fileName"
	nmap -sS -O $domain >> "$dirPath"/"$fileName"
	echo " " >> "$dirPath"/"$fileName"
	nmap -Pn $domain >> "$dirPath"/"$fileName"
	echo " " >> "$dirPath"/"$fileName"
	nmap -Pn $domain -p 20,21,22,23,25,80,107,115,546,547,666,992,31337 >> "$dirPath"/"$fileName"
	echo " " >> "$dirPath"/"$fileName"
	echo "###########################" >> "$dirPath"/"$fileName"
fi

echo " "
rm -f ./temp.txt
echo "Done."
echo " " >> "$dirPath"/"$fileName"
echo "All done in `date`" >> "$dirPath"/"$fileName"
echo " " >> "$dirPath"/"$fileName"

