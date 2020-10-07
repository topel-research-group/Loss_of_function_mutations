#!/bin/bash

#This script creates .sge files for each sample so cutadapt, bowtie2 can run in parallel for multiple samples.
#André Soares - 23/03/2020 - Quarantined and bored

#path for v1.1.2 reference
REF_FASTA="/proj/data26/Skeletonema_marinoi_genome_project/12_remove_redundancy/Fake_Primary_Removal/Smar_v1.1.2"

#build bowtie2 index for v1.1.2 reference
#bowtie2-build --threads $NSLOTS $REF_FASTA Smar_v1.1.2
#this will need to be moved somewhere proper ASAP

for i in /proj/data17/Skeletonema_marinoi_adaptation_to_warming_project/00_data/Trimmed/P*; do
	#check if it's a directory
        [ -d "${i}" ] || continue

	#dirname for sample name
        dirname="$(basename "${i}")"

	#form mate pair names
        MATE1=($i"/"$dirname"_R1.Pair.fastq.gz")
        MATE2=($i"/"$dirname"_R2.Pair.fastq.gz")

	#create variables GROUP, QUEUE to feed into pindel and sge files
        spl_no=$(echo $dirname | cut -d '_' -f2)
        if [ "$spl_no" -gt 100 ] && [ "$spl_no" -lt 112 ]; then
#        GROUP="GP2_"$dirname
        QUEUE="Annotation-4"
        elif [ "$spl_no" -gt 113 ] && [ "$spl_no" -lt 124 ]; then
#        GROUP="VG1_"$dirname
        QUEUE="Annotation-2"
        elif [ "$spl_no" -gt 125 ] && [ "$spl_no" -lt 136 ]; then
#        GROUP="LO_"$dirname
        QUEUE="Annotation-3"
        elif [ "$spl_no" -gt 137 ] && [ "$spl_no" -lt 150 ]; then
#        GROUP="Mutant_"$dirname
        QUEUE="Annotation-1"
        fi;
	
	#echo $spl_no
	#echo $QUEUE

	touch $dirname"_script.sge"

	echo -e "#$ -cwd\n#$ -q "$QUEUE"\n#$ -S /bin/bash\n#$ -pe mpi 8\n" > $dirname"_script.sge"
	echo -e "\nmodule load Anaconda3/v2019.10\nmodule load Bowtie2/v2.3.4.3\nmodule load samtools/v1.9\n" >> $dirname"_script.sge"

	echo "#$ -o /proj/data9/Loss_of_function_mutations/01_Mapping_Lov" >> $dirname"_script.sge"
	echo -e "#$ -e /proj/data9/Loss_of_function_mutations/01_Mapping_Lov\n" >> $dirname"_script.sge"
	
	echo -e "mkdir -p "$dirname"\n" >> $dirname"_script.sge"

	#run bowtie2 against v1.1.2
	echo -e "bowtie2 -x "$REF_FASTA" --no-unal -p 8 -1 "$MATE1" -2 "$MATE2" -S "$dirname"/"$dirname".sam\n" >> $dirname"_script.sge"

	#create .bam and index it
	echo -e "samtools view -@ 8 -b -o "$dirname"/"$dirname".bam "$dirname"/"$dirname".sam\n" >> $dirname"_script.sge"
	echo -e "samtools sort -@ 8 -o "$dirname"/"$dirname"_sorted.bam "$dirname"/"$dirname".bam\n" >> $dirname"_script.sge"
	echo -e "samtools index "$dirname"/"$dirname"_sorted.bam "$dirname"/"$dirname"_sorted.bai\n" >> $dirname"_script.sge"

	qsub $dirname"_script.sge"
done
