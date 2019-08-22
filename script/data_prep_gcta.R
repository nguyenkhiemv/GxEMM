rm( list = ls() )

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

#covariate file (diagnosis only) for gcta
covar<-cb
