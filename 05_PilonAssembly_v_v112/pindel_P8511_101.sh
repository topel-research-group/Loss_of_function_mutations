#!/bin/bash

study="P8511_101"
date_lbl=$(date +"%m-%d-%y")
v112_GFF="/proj/data26/Skeletonema_marinoi_genome_project/03_Annotation/Skeletonema_marinoi_Ref_v1.1_Primary/Unique_models_per_locus_ManualCuration/Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene.gff"
v112_FASTA="/proj/data9/Loss_of_function_mutations/02_SV_calling_Pindel/Smar_v1.1.2.fasta"

echo -e "#$ -cwd\n#$ -q Annotation-4\n#$ -S /bin/bash\n#$ -pe mpi 8\n" > $study"_pindel_script.sge"
echo -e "module load pindel/v0.2.5b8\n" >> $study"_pindel_script.sge"

#create folders in 02_SV_calling_Pindel
echo -e "mkdir -p pindel_"$study"\n" >> $study"_pindel_script.sge"

#convert .sam alignments into pindel-friendly format
echo -e "sam2pindel map_"$study"/"$study".sam pindel_"$study"/"$study"_pindel.txt 150 Pilon_Assembly 0 Illumina-PairEnd\n" >> $study"_pindel_script.sge"

#run pindel
echo -e "pindel -f "$v112_FASTA" -p pindel_"$study"/"$study"_pindel.txt -o pindel_"$study"/"$study" -c ALL -T 8 -x 8\n" >> $study"_pindel_script.sge"

#convert pindel output to vcf and compress
echo -e "pindel2vcf -P pindel_"$study""/""$study" -r "$v112_FASTA" -R S_marinoi_v1.1.2 -d "$date_lbl" -v pindel_"$study"/"$study"_S_marinoi_v1.1.2.vcf\n" >> $study"_pindel_script.sge"
echo -e "bgzip -c pindel_"$study"/"$study"_S_marinoi_v1.1.2.vcf > pindel_"$study"/"$study"_S_marinoi_v1.1.2.vcf.gz" >> $study"_pindel_script.sge"

#submit, evil laugh
qsub $study"_pindel_script.sge"

