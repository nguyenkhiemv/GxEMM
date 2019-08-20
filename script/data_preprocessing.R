rm( list=ls() )

###########################################   file format to get cisSNP for each gene by plink #########
## need 4 columns per row: chromosome, start basepair, end basepair, gene name##########################
########################################################################################################
#load data
load('se.CombinedDataForPrimaryAnalysis.RData')

#extract gene position
matrix.gene.pos <- se.Primary@elementMetadata[ ,c( 'chr','start','stop','gene_id' ) ]
#format for plink input
matrix.gene.pos$chr <- sapply( strsplit( matrix.gene.pos$chr,'r' ), function(x) x[[2]] )
#remove gene on sex chromosome
sexchr   <- which( matrix.gene.pos$chr %in% c( 'X', 'Y') )
matrix.gene.pos<-matrix.gene.pos[-sexchr,]
print('check gene pos matrix')
head(matrix.gene.pos)
#write the matrix
matrix.gene.pos[,4]<-as.character(matrix.gene.pos[,4])
write.table(matrix.gene.pos,file='matrix.gene.pos.for.eqtl', row.names = F, col.names = F,quote = F)
