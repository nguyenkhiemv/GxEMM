#calculate kinship matrix for each gene based on cis SNP only ( 1 Mb window )
#SNP for all genes using 1Mb window
system('~/softwares/plink/plink --bfile COMMONMIND.EUR.QC.EXPR.KEEP.rmAFF --make-set gene.list.1_1000 --make-set-border 1000 --write-set --out cisSNP_list')


#extract cisSNP genotype bed file for each gene
#system("~/softwares/plink/plink --noweb --bfile PsychEncode.QC.MAF0.05.EXPR.Nonrel --set cisSNP_list_22001_24905.set  --gene $(awk -v gene=$SGE_TASK_ID 'NR==gene' gene.symbol) --make-bed --out /scrapp/gene_$SGE_TASK_ID")

#use GCTA to calculate kinship matrix and store for GxEMM usex
#system('~/softwares/gcta/gcta64 --bfile /scrapp/gene_$SGE_TASK_ID  --autosome --make-grm --out ./cisSNP_kinship/kin_$SGE_TASK_ID')
#
