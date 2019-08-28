# read kinship matrix
i<-as.numeric(commandArgs(TRUE)[1])
#function to read kinship matrix from GCTA bim file
source('~/PsychEncode/QC_geno/readWriteGrmGCTA.r')

grm<-ReadGRMBin(paste0('./cisSNP_kinship/kin_',i))
K<-grm$GRM
################GxEMM##########################

library(gxemm)

####################### Nonpermute GxEMM #################
########################################################
#load covariate,expression,disease file
load('data.for.gxemm.rdata')

#expression data
y<-as.matrix(expression[,i])
rm(expression)

#head(y)
#mean(y)
#
#try({
##GxEMM calculation
#out_hom <- GxEMM( y, X=X, K, Z=Z, gtype='hom',ldak_loc='~/GxEMM/code/ldak5.linux')
#out_iid <- GxEMM( y, X=X, K, Z, gtype='iid' )
#out_free_dumb <- GxEMM( y, X=X, K, Z=Z, gtype='free',etype='hom')
#out_free <- GxEMM( y, X=X, K, Z=Z, gtype='free',etype='free')
#out_ghom_efree<-GxEMM(y,X=X,K,Z=Z,gtype='hom',etype='free')
#
#save(out_hom,out_iid,out_free_dumb,out_free,out_ghom_efree,file=paste0('./GxEMM/output_',i,'.rdata'))
#rm(list=ls(pattern='out'))
# })
##

############################# permutation all gxemm##############3

y_per_all <- array(NA, dim=c( length(y), 10))

for (j in 3:10) {
        y_per_all[,j] <- sample(y)
      }

#head(y_per_all)
#apply(y_per_all, 2, mean)

for (j in 3:10) {
        try({
        #GxEMM calculation
        out_hom <- GxEMM(y= y_per_all[,j], X=X, K, Z=Z, gtype='hom',ldak_loc='~/GxEMM/code/ldak5.linux')
        out_iid <- GxEMM(y=y_per_all[,j] , X=X, K, Z, gtype='iid' )
        out_free_dumb <- GxEMM( y=y_per_all[,j], X=X, K, Z=Z, gtype='free',etype='hom')
        out_free <- GxEMM( y=y_per_all[,j] , X=X, K, Z=Z, gtype='free',etype='free')
        out_ghom_efree<-GxEMM(y=y_per_all[,j] ,X=X,K,Z=Z,gtype='hom',etype='free')

save(out_hom,out_iid,out_free_dumb,out_free,out_ghom_efree,file=paste0('./GxEMM_permute/permutation_all_',j,'/output_',i,'.rdata'))
rm(list=ls(pattern='out'))
 })
 }
rm(y_per_all)


################### permutation within subtype###
################################################
#permute expression file within subtype 10 times
#load disease file
disease<-read.table('./GCTA/covar.txt')

y_per_wi <- array(NA, dim= c( length(y), 10))

for (j in 3:10) {
        for (group in c('BP','Control','Schizophrenia')) {
                         y_per_wi[,j][disease[,3]==group] <- sample( y[disease[,3]==group])

                                                }
                        }

#head(y_per_wi)
#apply(y_per_wi, 2, mean)
#mean(y[disease[,3] == 'Control'])
#mean(y_per_wi[,1][disease[,3] == 'Control'])
#mean(y_per_all[,1][disease[,3] == 'Control'])

for (j in 3:10) {
        try({
        #GxEMM calculation
        out_hom <- GxEMM(y= y_per_wi[,j], X=X, K, Z=Z, gtype='hom',ldak_loc='~/GxEMM/code/ldak5.linux')
        out_iid <- GxEMM(y= y_per_wi[,j], X=X, K, Z, gtype='iid' )
                                                                        out_free_dumb <- GxEMM( y=y_per_wi[,j], X=X, K, Z=Z, gtype='free',etype='hom')
        out_free <- GxEMM( y=y_per_wi[,j], X=X, K, Z=Z, gtype='free',etype='free')
        out_ghom_efree<-GxEMM(y=y_per_wi[,j],X=X,K,Z=Z,gtype='hom',etype='free')

save(out_hom,out_iid,out_free_dumb,out_free,out_ghom_efree,file=paste0('./GxEMM_permute/within_subtype_',j,'/output_',i,'.rdata'))
rm(list=ls(pattern='out'))
 })
}

