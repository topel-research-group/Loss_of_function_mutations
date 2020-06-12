#!/bin/bash

study="P8511_101"

#create sge file, feed it the basics
echo -e "#$ -cwd\n#$ -q sandbox\n#$ -S /bin/bash\n#$ -pe mpi 1\n" > $study"_snpEff_script.sge"
echo -e "module load Java/v1.8.0_191\nmodule load snpEff/v.4.3t\n" >> $study"_snpEff_script.sge"

echo -e "mkdir snpEff_"$study >> $study"_snpEff_script.sge"
echo -e "sed 's/^0/Sm_0/g' pindel_"$study"/P8511_101_D_S_marinoi_v1.1.2.vcf > snpEff_"$study"/"$study"_D_ChrNamesCor.vcf" >> $study"_snpEff_script.sge"
echo -e "snpEff eff Smarinoi.v112 snpEff_"$study"/"$study"_D_ChrNamesCor.vcf -c /home/andre/snpEff.config -csvStats snpEff_"$study"/"$study"_D_summary.csv > snpEff_"$study"/"$study".ann.vcf" >> $study"_snpEff_script.sge"

qsub $study"_snpEff_script.sge"

