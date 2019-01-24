#! /bin/bash

PROJECTDIR="/projects/sanchez_share/AutoSeg_EESND/Final_runs"
OUTPUT="/projects/sanchez_share/AutoSeg_EESND/Analysis"

# Start processing loop

cd ${PROJECTDIR}
ls | grep -v / | tr '\n' ' ' > ${OUTPUT}/subjects.txt

cd ${OUTPUT}
rm Raw_data/Volume*.csv
rm Raw_data/TissueSegVolume.csv


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

done

cd ${OUTPUT}

Rscript Structural_data_reshape.R

cd ${OUTPUT}
mv Volume*.csv Raw_data/
mv TissueSegVolume.csv Raw_data/

mv *final.csv Final_data/

echo 'Analysis Executed Cleanly'
