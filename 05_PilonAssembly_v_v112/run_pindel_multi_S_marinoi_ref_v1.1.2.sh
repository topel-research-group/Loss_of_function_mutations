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

for i in /proj/data9/Loss_of_function_mutations/01_Mapping/P*/; do
	#check if it's a directory
        [ -d "${i}" ] || continue

	#dirname for sample name
        dirname="$(basename "${i}")"

	#create variables GROUP, QUEUE to feed into pindel and sge files
        spl_no=$(echo $dirname | cut -d '_' -f2)
        if [ "$spl_no" -gt 100 ] && [ "$spl_no" -lt 128 ]; then
        GROUP="GP2_"$dirname
	QUEUE="Annotation-1"
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
	echo -e "#$ -cwd\n#$ -q ""$QUEUE""\n#$ -S /bin/bash\n#$ -pe mpi 8\n" > $dirname"_script.sge"
	echo -e "module load pindel/v0.2.5b8\nmodule load ensembl-vep/vX.X\n" >> $dirname"_script.sge"

	#create folders in 02_SV_calling_Pindel
	#echo -e "mkdir -p "$dirname"\n" >> $dirname"_script.sge"

	#convert .sam alignments into pindel-friendly format
	#echo -e "sam2pindel "$i""$dirname".sam "$dirname"/"$dirname"_pindel.txt 150 "$GROUP" 0 Illumina-PairEnd\n" >> $dirname"_script.sge"
	
	#run pindel
	#echo -e "pindel -f "$v112_FASTA" -p "$dirname"/"$dirname"_pindel.txt -o "$dirname"/"$dirname" -c ALL -T 8\n" >> $dirname"_script.sge"

	#convert pindel output to vcf and compress
	echo -e "pindel2vcf -P "$dirname""/""$dirname"_D -r "$v112_FASTA" -R S_marinoi_v1.1.2 -d "$date_lbl" -v "$dirname"/"$dirname"_D_S_marinoi_v1.1.2.vcf\n" >> $dirname"_script.sge"
	echo -e "bgzip -c "$dirname"/"$dirname"_D_S_marinoi_v1.1.2.vcf > "$dirname"/"$dirname"_D_S_marinoi_v1.1.2.vcf.gz" >> $dirname"_script.sge"

	#submit, evil laugh
	qsub $dirname"_script.sge"	
done
