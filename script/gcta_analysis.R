########## For cluster run #########################################
####################################################################
# REML by gcta (with no constrain option)
system( '~/softwares/gcta/gcta64 --reml-no-constrain --grm ./cisSNP_kinship/kin_$SGE_TASK_ID 
        --pheno ./GCTA/expression.dat --mpheno $SGE_TASK_ID --covar ./GCTA/covar.txt 
        --qcovar ./GCTA/qcovar.txt --out ./GCTA/reml/reml_$SGE_TASK_ID')

#REML with gxe 
#system( '~/softwares/gcta/gcta64 --reml-no-constrain --grm ./cisSNP_kinship/kin_$SGE_TASK_ID 
          --pheno ./GCTA/expression.dat --mpheno $SGE_TASK_ID --qcovar ./GCTA/qcovar.txt --gxe ./GCTA/covar.txt 
          --out ./GCTA/gxe/reml_gxe_$SGE_TASK_ID' )                                                              

#remove intermediate file m
#system( 'rm /scrapp/gene_$SGE_TASK_ID*' )
