#calculate kinship matrix for each gene based on cis SNP only ( 1 Mb window )
#create set file by plink
system( "sed -n '22001,24905 p' matrix.gene.pos.for.eqtl> gene.list.run" )

system( '~/softwares/plink/plink --noweb --bfile PsychEncode.QC.MAF0.05.EXPR.Nonrel
        --make-set gene.list.run --make-set-border 1000 --write-set --out cisSNP_list_22001_24905')

#create bedfile for each gene with cisSNP
#system("~/softwares/plink/plink --noweb --bfile PsychEncode.QC.MAF0.05.EXPR.Nonrel --set cisSNP_list_2001_4000.set  --gene $(awk -v gene=$SGE_TASK_ID 'NR==gene' gene.symbol) --make-bed --out /scrapp/gene_$SGE_TASK_ID")

#calculate kinship matrix by GCTA
#system('~/softwares/gcta/gcta64 --bfile /scrapp/gene_$SGE_TASK_ID  --autosome --make-grm --out ./cisSNP_kinship/kin_$SGE_TASK_ID')
