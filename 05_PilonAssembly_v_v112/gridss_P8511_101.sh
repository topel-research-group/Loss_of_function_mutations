#!/bin/bash

study="P8511_101"
date_lbl=$(date +"%m-%d-%y")
v112_GFF="/proj/data26/Skeletonema_marinoi_genome_project/03_Annotation/Skeletonema_marinoi_Ref_v1.1_Primary/Unique_models_per_locus_ManualCuration/Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene.gff"
v112_FASTA="/proj/data26/Skeletonema_marinoi_genome_project/12_remove_redundancy/Fake_Primary_Removal/Smar_v1.1.2.fasta"

echo -e "#$ -cwd\n#$ -q high_mem\n#$ -S /bin/bash\n#$ -pe mpi 20\n" > $study"_gridss_script.sge"
echo -e "module load gridss/v2.8.3\nmodule load picard/v2.18.26\nmodule load Java/v1.8.0_191\nmodule load Bowtie2/v2.3.4.3\nmodule load bwa/v0.7.17\n" >> $study"_gridss_script.sge"

#create folders in 02_SV_calling_Pindel
echo -e "mkdir -p gridss_"$study"\n" >> $study"_gridss_script.sge"

#run gridss
echo -e "gridss.sh -r "$v112_FASTA" map_"$study"/"$study".bam -t 20 -o gridss_"$study"/"$study"_PilonAssemblyExtraReads_sorted_ann.vcf -a gridss_"$study"/"$study"_PilonAssemblyExtraReads_sorted_ann_assembly.bam -j /usr/local/packages/gridss-2.8.3/gridss-2.8.3-gridss-jar-with-dependencies.jar\n" >> $study"_gridss_script.sge"

#submit, evil laugh
qsub $study"_gridss_script.sge"

