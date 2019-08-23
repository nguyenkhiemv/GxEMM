rm( list = ls() )

######################## Format expression matrix, covariates, quantiative covariates#############
#                        for GCTA analysis 
#################################################################################################
library(car)
################## Expression matrix ##########################
###############################################################
#expression matrix for gcta input with final list of individual
load( 'datExpr_allRegressed.Rdata' )
expression <- datExpr[ , match(rownames(metadata_with_gnt),colnames(datExpr))]

#remove genes on sex chromosome
expression<-expression[match(matrix.gene.pos$gene_id,rownames(expression)),]
dim(expression)
expression[1:5,1:5]
rm(datExpr)

#add two column of id for gcta
expression <- cbind(as.data.frame(metadata_with_gnt[,16]),as.data.frame(metadata_with_gnt[,16]), t(expression) )
write.table( expression, file='./GCTA/expression.dat', row.names = F, col.names = F, quote=F )

######################## Catagorical covariates #######################################################
#######################################################################################################

#covariate file (diagnosis only) for gcta
covar <- cbind( as.data.frame(metadata_with_gnt$individualID), as.data.frame(metadata_with_gnt$individualID),
               as.data.frame(metadata_with_gnt$diagnosis))
covar[,3]<-recode(covar[,3],"'Bipolar Disorder'='BP'") #recode to avoid space between two words
write.table( covar,file='./GCTA/covar.txt', row.names=F, col.names=F, quote=F )

################################# Quantiative covariates (10 PC ) #######################################
########################################################################################################
#calculate kinship matrix and PC of kinship matrix as covariate for calculation
system( '~/softwares/gcta/gcta64 --bfile PsychEncode.QC.MAF0.05.EXPR.Nonrel 
      --autosome --make-grm --out PsychEncode.QC.MAF0.05.EXPR.Nonrel.kinship')

#calculate 10 PC of kinship matrix
system( '~/softwares/gcta/gcta64 --grm PsychEncode.QC.MAF0.05.EXPR.Nonrel.kinship 
      --pca 10 --out PsychEncode.QC.EXPR.MAF0.05.Nonrel.kinship')

#quantiative covariates for gcta
qcovar <- read.table('PsychEncode.QC.EXPR.MAF0.05.Nonrel.kinship.eigenvec')
write.table( qcovar, file='./GCTA/qcovar.txt',row.names=F,col.names=F,quote=F )

