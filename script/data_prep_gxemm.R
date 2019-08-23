rm(list=ls())
sink('data_prep_gxemm.out')

#load expression file formated for gcta
expression <- read.table('./GCTA/expression.dat')
#remove two ID column for gxemm input
expression <- expression[,-c(1,2)]

#prepare Z matrix (environment: disease status)
covar <- read.table('./GCTA/covar.txt')
Z <- as.factor(covar[,3])
Z <- model.matrix(~0+Z,data=Z)

#prepare X matrix ( 10 PC and disease status)
qcovar <- read.table( './GCTA/qcovar.txt' ) #load 10 PC of genetic matrix
qcovar <- qcovar[,-c(1,2)] #remove two ID columns
X <- cbind(qcovar,Z[,-2])
X <- scale(X)
head(X)

save(X,Z,expression,file='data.for.gxemm.rdata')
                   
