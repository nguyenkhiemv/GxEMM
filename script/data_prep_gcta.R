#expression matrix for gcta with non rel individuals and no Autsim spectrum disorder sample
load('/ye/zaitlenlabstore/andy/for_khiem/datExpr_allRegressed.Rdata')
expression<-datExpr[,match(rownames(metadata_with_gnt),colnames(datExpr))]

#remove gene on sex chromosome
expression<-expression[match(matrix.gene.pos$gene_id,rownames(expression)),]
print('dimension of expression matrix')
dim(expression)
expression[1:5,1:5]
print('gene pos matrix')
head(matrix.gene.pos)
rm(datExpr)

#add two column of id for gcta
expression<-cbind(as.data.frame(metadata_with_gnt[,16]),as.data.frame(metadata_with_gnt[,16]),t(expression))
write.table(expression,file='./GCTA/expression.dat',row.names = F, col.names = F, quote=F)

#covariate file (diagnosis only) for gcta
covar<-cb
