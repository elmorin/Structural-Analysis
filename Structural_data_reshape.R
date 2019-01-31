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
write.csv(Tissue_reshape, 'Tissue_final.csv', row.names=F)

#Label 2 - GM - rmANOVA
label_2_subjects_ages <- as.matrix(t(as.data.frame(str_split(Label_2[,1], "_", n=3))))
label_2_dataset <- as.data.frame(cbind(label_2_subjects_ages[,1:2],Label_2[,3:30]))
colnames(label_2_dataset) <- c('Subject','Age','R_Occipital','R_Temporal_Auditory', 
                               'R_Subcortical','R_Frontal','R_Cerebellum', 'R_Insula','R_Cingulate','R_Parietal',
                               'R_Prefrontal','R_Corpus_Callosum','R_Temporal_Visual','R_Temporal_Limbic',
                               'R_Pons_Medulla','L_Occipital','L_Temporal_Auditory','L_Subcortical','L_Frontal',
                               'L_Cerebellum','L_Insula','L_Cingulate','L_Parietal','L_Prefrontal','L_Corpus_Callosum',
                               'L_Temporal_Visual','L_Temporal_Limbic','L_Pons_Medulla','R_Lat_Ventricle',
                               'L_Lat_Ventricle')
label_2_reshape <- reshape(label_2_dataset, idvar="Subject", timevar = "Age", direction="wide")
rownames(label_2_reshape) <- NULL
write.csv(label_2_reshape, 'Label_2_GM_final_rmANOVA.csv')

#Label 2 - GM - MLM
label_2_subjects_ages <- as.matrix(t(as.data.frame(str_split(Label_2[,1], "_", n=3))))
label_2_dataset <- as.data.frame(cbind(label_2_subjects_ages[,1:2],Label_2[,3:30]))
rownames(label_2_dataset) <- NULL
Right <- label_2_dataset[,3:15]
Right <- cbind(Right, label_2_dataset[,29])
colnames(Right) <- c('Occipital','Temporal_Auditory', 'Subcortical','Frontal','Cerebellum', 'Insula','Cingulate','Parietal',
                               'Prefrontal','Corpus_Callosum','Temporal_Visual','Temporal_Limbic','Pons_Medulla','Lat_Ventricle')
Hemisphere <- as.data.frame(rep("Right",nrow(Right)))
Right <- cbind(Hemisphere,Right)
colnames(Right)[1] <- "Hemisphere"
Sex <- as.data.frame(rep("Sex",nrow(Right)))
Right_names <- cbind(label_2_dataset[,1:2], Sex,Right) 
colnames(Right_names)[1:3] <- c("Subject","Age","Sex")
Left <- label_2_dataset[,16:28]
Left <- cbind(Left, label_2_dataset[,30])
colnames(Left) <- c('Occipital','Temporal_Auditory', 'Subcortical','Frontal','Cerebellum', 'Insula','Cingulate','Parietal',
                    'Prefrontal','Corpus_Callosum','Temporal_Visual','Temporal_Limbic','Pons_Medulla','Lat_Ventricle')
Hemisphere <- as.data.frame(rep("Left",nrow(Left)))
Left <- cbind(Hemisphere,Left)
colnames(Left)[1] <- "Hemisphere"
Left_names <- cbind(label_2_dataset[,1:2], Sex,Left) 
colnames(Left_names)[1:3] <- c("Subject","Age","Sex")
label_2_MLM <- rbind(Right_names, Left_names)
label_2_MLM_sort <- label_2_MLM[order(label_2_MLM$Subject),] 
write.csv(label_2_MLM_sort, 'Label_2_GM_final_MLM.csv')

#Subcortical - rmANOVA
subcort_subjects_ages <- as.matrix(t(as.data.frame(str_split(Subcortical[,1], "_", n=3))))
subcort_dataset <- as.data.frame(cbind(subcort_subjects_ages[,1:2],Subcortical[,3:10]))
colnames(subcort_dataset)<- c('Subject','Age','R_Hippocampus','R_Amygdala','R_Caudate','R_Putamen',
                              'L_Hippocampus','L_Amygdala','L_Caudate','L_Putamen')
subcort_reshape <- reshape(subcort_dataset, idvar="Subject", timevar = "Age", direction="wide")
rownames(subcort_reshape) <- NULL
write.csv(subcort_reshape, 'Subcortical_GM_final_rmANOVA.csv')

#Subcortical - MLM
subcort_subjects_ages <- as.matrix(t(as.data.frame(str_split(Subcortical[,1], "_", n=3))))
subcort_dataset <- as.data.frame(cbind(subcort_subjects_ages[,1:2],Subcortical[,3:10]))
rownames(subcort_dataset) <- NULL
Right_sc <- subcort_dataset[,3:6]
colnames(Right_sc)<- c('Hippocampus','Amygdala','Caudate','Putamen')
Hemisphere <- as.data.frame(rep("Right",nrow(Right_sc)))
Right_sc <- cbind(Hemisphere,Right_sc)
colnames(Right_sc)[1] <- "Hemisphere"
Sex <- as.data.frame(rep("Sex",nrow(Right_sc)))
Right_sc_names <- cbind(subcort_dataset[,1:2], Sex,Right_sc) 
colnames(Right_sc_names)[1:3] <- c("Subject","Age","Sex")
Left_sc <- subcort_dataset[,7:10]
colnames(Left_sc)<- c('Hippocampus','Amygdala','Caudate','Putamen')
Hemisphere <- as.data.frame(rep("Left",nrow(Left_sc)))
Left_sc <- cbind(Hemisphere,Left_sc)
colnames(Left_sc)[1] <- "Hemisphere"
Sex <- as.data.frame(rep("Sex",nrow(Left_sc)))
Left_sc_names <- cbind(subcort_dataset[,1:2], Sex,Left_sc) 
colnames(Left_sc_names)[1:3] <- c("Subject","Age","Sex")
subcort_MLM <- rbind(Right_sc_names, Left_sc_names)
subcort_MLM_sort <- subcort_MLM[order(subcort_MLM$Subject),] 
write.csv(subcort_MLM_sort, 'Subcortical_GM_final_MLM.csv')
