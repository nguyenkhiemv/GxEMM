#extract cisSNP (1 Mb window) for each gene
#save as a plink set file for all genes between ith and jth rows of gene pos matrix
#i,j: gene index (row # of gene pos matrix
#############################################################################################

i <- as.numeric(commandArgs(TRUE)[1])
j <- as.numeric(commandArgs(TRUE)[2])

#create set file by plink
system( paste0( 'sed -n ',"'" ,i ,',', j , ' p',"'",' matrix.gene.pos.for.eqtl> gene.list.run_',i ) )

#extract cisSNP for each gene
system( paste0( '~/softwares/plink/plink --noweb',
        ' --bfile PsychEncode.QC.MAF0.05.EXPR.Nonrel.eur --make-set gene.list.run_',i,
        ' --make-set-border 1000 --write-set --out cisSNP_list_',i, '_', j  ))
