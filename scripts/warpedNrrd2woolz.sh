#!/bin/bash
# Exploads the warped .nrrd file as a series of tiffs ; then creates woolz out of these
# Params: 
# 1: nrrd file to be processed
# 2: the "base directory " - parent directory where all the scripts are stored 
# It is presumed that the metadata (wlz_meta) folder should be in the same folder with all the images
# NB: has to be run from the loopThroughFiles.bsh to loop through all nrrds in a folder
#NB: Should be run from the folder where all the nrrd files stored
set -x 
echo "Processing file: " $1 "Base dir: " $2
cd $2
export baseDir=`pwd`
cd -
export sriptDir='../scripts/'
export woolzDir='/disk/data/VFBTools/Woolz2013Full/bin/'
export fijiBin='/disk/data/VFBTools/Fiji/ImageJ-linux64'

# YOu have to be in the the root of the individual stack folder for starters
#Creating Woolz file: exploding LSM->TIFF
dirName=`echo $1| sed s/.nrrd//`
echo "dir name: "$dirName
mkdir $dirName $dirName/wlz/  

python /disk/data/VFBTools/python\ packages/Bound.py 3 $1 $dirName/$1
rm $1
script=$fijiBin' -macro '$sriptDir'nrrd2tif.ijm '${dirName}/${1}' -batch'
#echo "Executing script: "$script
$script

#Creating Woolz file: Creating woolz

script=$woolzDir'WlzExtFFConvert -f tif -F wlz -o '$dirName'/wlz/0020.wlz '$dirName'/'${1/.nrrd/.tif}
#echo "Folder: "$dirName 
echo "Script: " $script
$script
echo "Created woolz!"

cd $dirName/wlz/
script=$woolzDir"WlzThreshold -v2 0020.wlz"
echo "Theshold: " $script
eval $script > ./0021.wlz

script=$woolzDir"WlzSetVoxelSize -x1 -y1 -z1.5 0021.wlz"
echo "Script4: " $script
eval $script > ./002.wlz

rm ./0020.wlz ./0021.wlz 
echo "Converted woolz successfully!"

echo "Processing metadata:"
cd ../../
rm  $dirName/*.tif
rm  $dirName/*.nrrd 
pwd
cp -rfv './wlz_meta' ./$dirName
rm './'$dirName'/wlz_meta/tiledImageToolParams.jso'
echo $dirName
dir=`echo $dirName |sed 's/.\///'` 
sedCmd="sed -i s:XXX:"$dir": $dirName/wlz_meta/tiledImageModelData.jso"
$sedCmd
