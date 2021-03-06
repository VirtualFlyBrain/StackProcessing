#!/bin/bash
# copies origianl NRRD files from AlignedData/XXX/ to WoolzData/XXX/ converting name using a name_mapping.csv file if one exists.
# run in StackProcessing directory: scripts/loadImageStacks.sh AlignedData/XXX/ WoolzData/XXX/

if [ -d ${1} ]
then
  if [ -d ${2} ]
  then
    echo "${2} already exists."
  else
    echo "creating ${2}.."
    mkdir ${2}
    cp .gitignore ${2}
  fi
else
  echo "Error: Directory ${1} does not exist!"
fi

if [ -f ${1}MissingFiles.log ]
then
  rm ${1}MissingFiles.log
fi

if [ -d ${1} ] && [ -d ${2} ]
then
  
  if [ -f ${1}/name_mapping.csv ]
  then
    echo "name_mapping.csv found.."
    while IFS=, read col1 col2
    do
      if [ -f ${1}${col1}.nrrd ]
      then
        echo "Moving: ${col1}.nrrd to ${col2}.nrrd"
        cp ${1}${col1}.nrrd ${2}${col2}.nrrd
      else
        echo "Error: ${1}${col1}.nrrd not found!"
        echo ${1}${col1}.nrrd >> ${1}MissingFiles.log
      fi
    done < ${1}/name_mapping.csv
  else
    echo "name_mapping.csv not found."
    echo "Moving: ${1}*.nrrd to ${2}"
    cp -v ${1}*.nrrd ${2}
  fi
else
  echo "Error: Directory ${2} does not exist!" 
fi
