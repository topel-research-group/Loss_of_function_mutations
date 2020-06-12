#!/bin/bash

#This script creates .sge files for each sample so cutadapt, bowtie2 can run in parallel for multiple samples.
#André Soares - 6/02/2020

#setting up a counter for S identifier after sample name
SC=20

#path for v1.1.2 reference
REF_FASTA="/proj/data26/Skeletonema_marinoi_genome_project/12_remove_redundancy/Fake_Primary_Removal/Smar_v1.1.2.fasta"

#build bowtie2 index for v1.1.2 reference
#bowtie2-build --threads $NSLOTS $REF_FASTA Smar_v1.1.2
#this will need to be moved somewhere proper ASAP

for i in /proj/data9/Loss_of_function_mutations/00_Data/P*; do
	#check if it's a directory
        [ -d "${i}" ] || continue

	#dirname for sample name
        dirname="$(basename "${i}")"

	#form mate pair names
        MATE1=($i"/"$dirname"_S"$SC"_L001_R1_001.fastq.gz")
        MATE2=($i"/"$dirname"_S"$SC"_L001_R2_001.fastq.gz")

	TMATE1=($i"/f15bptrimmed_"$dirname"_S"$SC"_L001_R1_001.fastq.gz")
	TMATE2=($i"/f15bptrimmed_"$dirname"_S"$SC"_L001_R2_001.fastq.gz")

	touch $dirname"_script.sge"

	echo -e "#$ -cwd\n#$ -q high_mem,Annotation-1,Annotation-2,Annotation-3,Annotation-4\n#$ -S /bin/bash\n#$ -pe mpi 8\n" > $dirname"_script.sge"
	echo -e "\nmodule load Anaconda3/v2019.10\nmodule load Bowtie2/v2.3.4.3\nmodule load samtools/v1.9\n" >> $dirname"_script.sge"
	
	#removes the first 15bp from Illumina reads. They showed < low quality on FastQC
	echo -e "cutadapt -u 15 -j 8 -o "$TMATE1" -p "$TMATE2" "$MATE1" "$MATE2"\n" >> $dirname"_script.sge"

	echo -e "mkdir -p "$dirname"\n" >> $dirname"_script.sge"

	#run bowtie2 against v1.1.2
	echo -e "bowtie2 -x /proj/data9/Loss_of_function_mutations/00_Data/Smar_v1.1.2 --no-unal -p 8 -1 "$TMATE1" -2 "$TMATE2" -S "$dirname"/"$dirname".sam\n" >> $dirname"_script.sge"

	#create .bam and index it
	echo -e "samtools view -@ 8 -b -o "$dirname"/"$dirname".bam "$dirname"/"$dirname".sam\n" >> $dirname"_script.sge"
	echo -e "samtools sort -@ 8 -o "$dirname"/"$dirname"_sorted.bam "$dirname"/"$dirname".bam\n" >> $dirname"_script.sge"
	echo -e "samtools index "$dirname"/"$dirname"_sorted.bam "$dirname"/"$dirname"_sorted.bai\n" >> $dirname"_script.sge"

	qsub $dirname"_script.sge"
	
	#advance counter
        ((SC++))
done
