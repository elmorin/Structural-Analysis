#! /bin/bash

PROJECTDIR=$1
PROJ=$2
OUTPUT="/projects/sanchez_share/structural_analyses"

# Start processing loop

cd ${PROJECTDIR}
ls | grep -v / | tr '\n' ' ' > ${OUTPUT}/subjects.txt

cd ${OUTPUT}

for SUB in $(cat ${OUTPUT}/subjects.txt) 

do

cd ${PROJECTDIR}/${SUB}/Analysis/AutoSeg_Volume

sed -n 8p AutoSeg_TissueSegmentationVolume.csv >> ${OUTPUT}/TissueSegVolume.csv
sed -n 7p AutoSeg_*_label_1.csv >> ${OUTPUT}/Volume_Label_1.csv
sed -n 7p AutoSeg_*_label_2.csv >> ${OUTPUT}/Volume_Label_2.csv
sed -n 7p AutoSeg_*_label_3.csv >> ${OUTPUT}/Volume_Label_3.csv
sed -n 7p AutoSeg_*_label_4.csv >> ${OUTPUT}/Volume_Label_4.csv
sed -n 7p AutoSeg_*_label_5.csv >> ${OUTPUT}/Volume_Label_5.csv
sed -n 7p AutoSeg_*2018_Volume.csv >> ${OUTPUT}/Volume_Subcort_new.csv
#Most updated edited Subcortical label files
#sed -n 7p AutoSeg_*05232018_Volume.csv >> ${OUTPUT}/Volume_Subcort_new.csv

done

cd ${OUTPUT}

Rscript /projects/sanchez_share/scripts/AutoSeg-Structural-Analysis/Structural_data_reshape.R

cd ${OUTPUT}

folder_name="${USER}--$(date +%Y-%m-%d)--${PROJ}"
mkdir Raw_data/"$folder_name"
mkdir Final_data/"$folder_name"

mv Volume*.csv Raw_data/"$folder_name"/
mv TissueSegVolume.csv Raw_data/"$folder_name"/
cp ${OUTPUT}/subjects.txt Raw_data/"$folder_name"/
mv ${OUTPUT}/subjects.txt Final_data/"$folder_name"


mv *final*.csv Final_data/"$folder_name"/

echo 'Analysis Executed Cleanly'
