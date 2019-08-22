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
#remove duplicated samples
metadata_with_gnt <- metadata_with_gnt[!duplicated(metadata_with_gnt$individualID),]
print( 'number of sample with both gnt and expression data after removing duplicated samples' )
dim(metadata_with_gnt)

# individual list with both gnt and expression data, formated for plink 
individual_list_keep <- cbind( as.data.frame(metadata_with_gnt[,16]), as.data.frame(metadata_with_gnt[,16]) )
write.table( individual_list_keep, file=paste0('individual_list_keep'), row.names = F, col.names = F, quote = F )

#create  plink bed file with individuals having both gnt and expression data
system( '~/softwares/plink/plink --bfile ~/PsychEncode/PsychEncode.QC.MAF0.05 
	--keep individual_list_keep --make-bed --out PsychEncode.QC.MAF0.05.EXPR')

#calculate kinship matrix by GCTA
system( '~/softwares/gcta/gcta64 --bfile PsychEncode.QC.MAF0.05.EXPR -
	-autosome --make-grm --out PsychEncode.QC.MAF0.05.EXPR_kinship' )

#generate list of non-related individual, remove all off-diagonal elements larger than 0.05
system( '~/softwares/gcta/gcta64 --grm PsychEncode.QC.MAF0.05.EXPR_kinship 
	--grm-singleton 0.05  --out PsychEncode.QC.MAF0.05.EXPR.Nonrel')
      
# reading list of non-related individuals
individual_list_nonrel <- read.table( 'PsychEncode.QC.MAF0.05.EXPR.Nonrel.singleton.txt' )

# metadata for non related individuals
metadata_with_gnt <- metadata_with_gnt[ match(individual_list_nonrel$V1, metadata_with_gnt$individualID),]
#print('number of sample after remove related-individual-final list of sample')
#dim(metadata_with_gnt)

# format individual list for plink input
individual_list_final <- cbind( as.data.frame(metadata_with_gnt[,16]),as.data.frame(metadata_with_gnt[,16]) )

#save final list of individual and metadata file
write.table( individual_list_final,file='individual_list_final',row.names = F, col.names = F,quote = F) 
save( metadata_with_gnt,file='meta_data_final.rdata' )
                
