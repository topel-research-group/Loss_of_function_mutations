#!/bin/bash

#This script takes bowtie2-mapped alignments to 1) transform them into pindel files, 2) call SVs with pindel, 
#3) generate .vcf files for detected SVs and 4) run the resulting .vcf against v.1.1.2 reference .fasta and .gff with vep
#
#The 3 for loops
#André Soares - 10/02/2020

date_lbl=$(date +"%m-%d-%y")
v112_GFF="/proj/data26/Skeletonema_marinoi_genome_project/03_Annotation/Skeletonema_marinoi_Ref_v1.1_Primary/Unique_models_per_locus_ManualCuration/Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene.gff"
#so this is awful but while I don't have access to /proj/data26 it will do
v112_FASTA="Smar_v1.1.2.fasta"

Pilon_D_REF="/proj/data9/Loss_of_function_mutations/05_PilonAssembly_v_v112/snpEff_P8511_101/P8511_101_D_ChrNamesCor.vcf"

for i in /proj/data9/Loss_of_function_mutations/04_SV_extraction/P*/*_D_ChrNamesCor.vcf; do

	#dirname for sample name
        filename="$(basename "${i}")"
	dirname="$(echo $filename | cut -f1,2 -d'_')"

	#create variables GROUP, QUEUE to feed into pindel and sge files
        spl_no=$(echo $dirname | cut -d '_' -f2)
        if [ "$spl_no" -gt 100 ] && [ "$spl_no" -lt 128 ]; then
        GROUP="GP2_"$dirname
	QUEUE="Annotation-4"
        elif [ "$spl_no" -gt 129 ] && [ "$spl_no" -lt 156 ]; then
        GROUP="VG1_"$dirname
	QUEUE="Annotation-2"
        elif [ "$spl_no" -gt 157 ] && [ "$spl_no" -lt 161 ]; then
        GROUP="LO_"$dirname
	QUEUE="Annotation-3"
        elif [ "$spl_no" -gt 162 ] && [ "$spl_no" -lt 194 ]; then
        GROUP="Mutant_"$dirname
	QUEUE="high_mem"
        fi;

	#create sge file, feed it the basics
	touch $dirname"_script.sge"
	echo -e "#$ -cwd\n#$ -q ""$QUEUE""\n#$ -S /bin/bash\n#$ -pe mpi 1\n" > $dirname"_script.sge"
	echo -e "module load Bedtools2/v2.27.1\n" >> $dirname"_script.sge"

	#create folders
	echo -e "mkdir -p "$dirname"_D\n" >> $dirname"_script.sge"

	echo -e "bedtools intersect -v -b "$Pilon_D_REF" -a "$i" -sorted > "$dirname"_D/"$dirname"_D_PilonMskd.vcf" >> $dirname"_script.sge"

	#submit, evil laugh
	qsub $dirname"_script.sge"	
done
