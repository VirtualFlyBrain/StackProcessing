#!/bin/bash
# Exploads the warped .nrrd file as a series of tiffs ; then creates woolz out of these
# YOu have to be in the the root of the individual stack folder for starters
# To run: from image folder, ../scripts/loopThroughFiles.bsh .. (Presuming all the metadata and 
# scripts are in the folder one level above)
set -x
#Bear in mind the ps itself creates process count = 1, so increasse this by 1
numProcesses=13
for file in $1/*nrrd
do
	if [[ -f $file ]]; then	
		echo "Processing "$file
		# Check the number of running processes 
		# If it is lower than numProcesses start another process
		# If it's greater, wait 10 s in a loop hoping that a process may finish
		procCount=`ps axu |grep warpedNrrd2woolz.sh|wc -l`
	        while [  $procCount -ge $numProcesses ]; do
	             sleep 10
		     procCount=`ps axu |grep warpedNrrd2woolz.sh|wc -l`
	        done
		# Fire another process in background
    		../scripts/warpedNrrd2woolz.bsh $file .. &
	fi
done

