# Structural-Analysis

## AutoSeg Structural Analysis Data Reshaping Script
Written by Elyse Morin


**Purpose:**

This script pulls the individual subject raw data from the nested AutoSeg output files and prepares compiled datasets (Total Tissue, Cortical Gray Matter Parcellations, and Subcortical Gray Matter Segmentations) ready for hypothesis testing (rmANOVA and MLM) 

**Usage:**

1. Place your final runs in a folder in your project directory.
2. From the here(/projects/sanchez_share/scripts/AutoSeg-Structural-Analysis
), run the script, providing the path to the folder you created with the final runs:<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For example:<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;./EESND_Structural_Analysis.sh /projects/sanchez_share/AutoSeg_EESND/Final_runs/

Your raw data .csv files and final data files will be placed in the appropriate folders.
