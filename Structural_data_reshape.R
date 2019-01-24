#!/usr/bin/Rscript


.libPaths("/projects/sanchez_share/AutoSeg_EESND/Analysis/R/library")

#install.packages('stringr', repos='http://cran.us.r-project.org')
library(stringr)

Tissue <- as.matrix(read.csv('TissueSegVolume.csv', header=F))
Label_1 <- read.csv('Volume_Label_1.csv', header=F)
Label_2 <- read.csv('Volume_Label_2.csv', header=F)
Label_3 <- read.csv('Volume_Label_3.csv', header=F)
Label_4 <- read.csv('Volume_Label_4.csv', header=F)
Label_5 <- read.csv('Volume_Label_5.csv', header=F)
Subcortical <- read.csv('Volume_Subcort_new.csv', header=F)

#Tissue
tissue_subjects_ages <- as.matrix(t(as.data.frame(str_split(Tissue[,1], "_", n=3))))
tissue_dataset <- as.data.frame(cbind(tissue_subjects_ages[,1:2],Tissue[,3:7]))
colnames(tissue_dataset) <- c('Subject','Age','WM','GM','CSF','Thalamus','Vessels_GP')
Tissue_reshape <- reshape(tissue_dataset, idvar="Subject", timevar = "Age", direction="wide")
rownames(Tissue_reshape) <- NULL
#Calculate ICV
write.csv(Tissue_reshape, 'Tissue_reshape.csv')
Tissue_reshape <- read.csv('Tissue_reshape.csv', header=T)
if (file.exists('Tissue_reshape.csv')){
  #Delete file if it exist
  file.remove('Tissue_reshape.csv')
};
Tissue_reshape <- Tissue_reshape[,-1]
Tissue_reshape$ICV.3mo <- rowSums(Tissue_reshape[, c('WM.3mo','GM.3mo','CSF.3mo','Thalamus.3mo','Vessels_GP.3mo')], na.rm = TRUE)
Tissue_reshape$ICV.6mo <- rowSums(Tissue_reshape[, c('WM.6mo','GM.6mo','CSF.6mo','Thalamus.6mo','Vessels_GP.6mo')], na.rm = TRUE)
Tissue_reshape$ICV.12mo <- rowSums(Tissue_reshape[, c('WM.12mo','GM.12mo','CSF.12mo','Thalamus.12mo','Vessels_GP.12mo')], na.rm = TRUE)
Tissue_reshape$Delta_ICV <- Tissue_reshape$ICV.12mo - Tissue_reshape$ICV.3mo
Tissue_reshape$Delta_GM <- Tissue_reshape$GM.12mo - Tissue_reshape$GM.3mo
Tissue_reshape$Delta_WM <- Tissue_reshape$WM.12mo - Tissue_reshape$WM.3mo
write.csv(Tissue_reshape, 'Tissue_final.csv')
