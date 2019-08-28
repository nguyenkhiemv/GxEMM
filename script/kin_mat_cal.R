######################calculate kinship matrix for each gene based on cis SNP only ( 1 Mb window ) from plink set file
## save as kin_i: i is index (row # of gene pos matrix )
## calculate for every 2000 genes #
#############################################################################################

#create bedfile for each gene 
system( "~/softwares/plink/plink --noweb --bfile PsychEncode.QC.MAF0.05.EXPR.Nonrel 
          --set cisSNP_list_2001_4000.set  --gene $(awk -v gene=$SGE_TASK_ID 'NR==gene' gene.symbol) 
           --make-bed --out /scrapp/gene_$SGE_TASK_ID" )

#calculate kinship matrix by GCTA
system( '~/softwares/gcta/gcta64 --bfile /scrapp/gene_$SGE_TASK_ID  
        --autosome --make-grm --out ./cisSNP_kinship/kin_$SGE_TASK_ID')
