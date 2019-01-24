# Structural-Analysis

##AutoSeg Structural Analysis Data Reshaping Script
Written by Elyse Morin


Purpose:

This script pulls the individual subject raw data from the nested AutoSeg output files and prepares compiled datasets (Total Tissue, Cortical Gray Matter Parcellations, and Subcortical Gray Matter Segmentations) ready for hypothesis testing (rmANOVA and MLM) 

Usage:

1. Place your final runs in the AutoSeg_EESND/Final_runs directory
2. Navigate to the Analysis folder and run the script:
     ./EESND_Structural_Analysis.sh

Your raw data .csv files and final data files will be placed in the appropriate folders.
