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
matrix.gene.pos <- matrix.gene.pos[-sexchr,]
print('check gene pos matrix')
head(matrix.gene.pos)
#write the matrix
matrix.gene.pos[,4] <- as.character( matrix.gene.pos[,4] )
write.table( matrix.gene.pos,file='matrix.gene.pos.for.eqtl', row.names = F, col.names = F,quote = F )
															
########## Matching samples that have both genotype data and expression data ##################
   #genotype samples: remove ASD samples, only keep 'frontal cortex' samples, remove duplicated sample 
################################################################################################
# load full metadata file
metadata <- as.data.frame( se.Primary@colData )
rm( se.Primary )

#sample from QC-ed genotype file
gnt_sample <- read.table( '~/PsychEncode/PsychEncode.QC.MAF0.05.fam' )

#keep samples with genotype data
keep <- as.character( intersect(gnt_sample$V1,metadata$individualID) )
metadata_with_gnt <- metadata[ metadata$individualID %in% keep, ]

#keep frontal cortex tissue samples
metadata_with_gnt <- metadata_with_gnt[ metadata_with_gnt$tissue=='frontal cortex', ]
print('number of frontal cortex samples')
dim(metadata_with_gnt)

#remove ASD samples 
ASD_samp <- which( metadata_with_gnt$diagnosis %in% c( 'Autism Spectrum Disorder' ) )
metadata_with_gnt <- metadata_with_gnt[ -ASD_samp, ]
print( 'number of sample after removing ASD' )
dim( metadata_with_gnt )

                
