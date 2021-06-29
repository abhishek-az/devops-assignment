#!/bin/bash

echo "Getting the third most CPU & Memory consuming process"

#Getting the list based on both cpu and memeory and storing them in a file called process.txt
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem,-%cpu | head -4 > process.txt #Here 4 is used since first line containes the headers

echo "Grabbing the required data and injecting"

#Now as we have the process.txt ready its time to use awk

#initializing
filename=result.txt

#checking if file is available or not
if [ -f $filename ]
then
 echo "file exists"
else
 echo "File doesn't exist"
 touch $filename 
fi


#Checking for the row number using iteration and sequence combo
for x in $(seq 1 5) 
do
 if [ $x -eq 3 ]
 then
   Process_name=$(awk 'NR==4 {print $3}' process.txt)
   echo "Process_name: "$Process_name >> $filename
 elif [ $x -eq 5 ]
 then
   CPU=$(awk 'NR==4 {print $5}' process.txt)
   echo "CPU-Utilization: "$CPU >> $filename
 elif [ $x -eq 4 ]
 then
   MEMORY=$(awk 'NR==4 {print $4}' process.txt)
   echo "RAM-Utilization: "$MEMORY >> $filename
 elif [ $x == 1 ]
 then
   PID_NUMBER=$(awk 'NR==4 {print $1}' process.txt)
   echo "PID: "$PID_NUMBER >> $filename
   PORT=$(lsof -Pan -p $PID_NUMBER -i)
   echo "PORT: "$PORT >> $filename
 else
  echo "Not required as per requirement"
 fi
done
 
#Cleaning up so that only one file remains at the end
rm process.txt
