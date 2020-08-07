#!/bin/bash

folder="/proj/data21/Skeletonema_marinoi/Genome/RO5/A.Blomberg_17_16-P8511/01-QC/P8511_101/fastq_trimmed/"
MATE1="P8511_101_S1_L001_R1_001.fastq"
MATE2="P8511_101_S1_L001_R2_001.fastq"
study="P8511_101"

echo -e "#$ -cwd\n#$ -q Annotation-1\n#$ -S /bin/bash\n#$ -pe mpi 20\n" > $study"_map_script.sge"
echo -e "\nmodule load Anaconda3/v2019.10\nmodule load Bowtie2/v2.3.4.3\nmodule load samtools/v1.9\n" >> $study"_map_script.sge"

echo -e "mkdir -p map_"$study"\n" >> $study"_map_script.sge"

#run bowtie2 against v1.1.2
echo -e "bowtie2 -x /proj/data26/Skeletonema_marinoi_genome_project/12_remove_redundancy/Fake_Primary_Removal/Smar_v1.1.2 --no-unal -p 20 -1 "$folder$MATE1" -2 "$folder$MATE2" -S map_"$study"/"$study".sam\n" >> $study"_map_script.sge"

#create .bam and index it
echo -e "samtools view -@ 20 -b -o map_"$study"/"$study".bam map_"$study"/"$study".sam\n" >> $study"_map_script.sge"
echo -e "samtools sort -@ 20 -o map_"$study"/"$study"_sorted.bam map_"$study"/"$study".bam\n" >> $study"_map_script.sge"
echo -e "samtools index map_"$study"/"$study"_sorted.bam map_"$study"/"$study"_sorted.bai\n" >> $study"_map_script.sge"

qsub $study"_map_script.sge"
