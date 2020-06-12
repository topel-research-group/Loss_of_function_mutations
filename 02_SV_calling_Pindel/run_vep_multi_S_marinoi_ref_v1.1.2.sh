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

#prepare GFF reference S.marinoi annotations for VEP --custom mode
#http://www.ensembl.org/info/docs/tools/vep/script/vep_custom.html

if [ ! -f Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene_noFASTA.gff.gz ]; then
	module load samtools/v1.9
	grep -v "#" Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene_noFASTA.gff | sort -k1,1 -k4,4n -k5,5n -t$'\t' | bgzip -c > Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene_noFASTA.gff.gz
	tabix -p gff Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene_noFASTA.gff.gz
fi

#downloaded phaeodactylum_tricornutum VEP annotations (VEP wouldn't run without ref) as follows
#mkdir $HOME/.vep
#cd $HOME/.vep
#curl -O ftp://ftp.ensemblgenomes.org/pub/protists/release-46/variation/vep/phaeodactylum_tricornutum_vep_46_ASM15095v2.tar.gz
#tar xzf phaeodactylum_tricornutum_vep_46_ASM15095v2.tar.gz
#convert_cache.pl -species phaeodactylum_tricornutum -version 46

#now for VEP!

for i in /proj/data9/Loss_of_function_mutations/02_SV_calling_Pindel/P14203_101/; do
	#check if it's a directory
        [ -d "${i}" ] || continue

	#dirname for sample name
        dirname="$(basename "${i}")"

	#create variable GROUP to feed into pindel
        spl_no=$(echo $dirname | cut -d '_' -f2)
        if [ "$spl_no" -gt 100 ] && [ "$spl_no" -lt 128 ]; then
        GROUP="GP2"
	QUEUE="Annotation-1"
        elif [ "$spl_no" -gt 129 ] && [ "$spl_no" -lt 156 ]; then
        GROUP="VG1"
	QUEUE="Annotation-2"
        elif [ "$spl_no" -gt 157 ] && [ "$spl_no" -lt 161 ]; then
        GROUP="LO"
	QUEUE="Annotation-3"
        elif [ "$spl_no" -gt 162 ] && [ "$spl_no" -lt 194 ]; then
        GROUP="Mutant"
	QUEUE="high_mem"
        fi;

	#create sge file, feed it the basics
	touch $dirname"_vep_script.sge"
	echo -e "#$ -cwd\n#$ -q ""$QUEUE""\n#$ -S /bin/bash\n#$ -pe mpi 8\n" > $dirname"_vep_script.sge"
	echo -e "module load pindel/v0.2.5b8\nmodule load ensembl-vep/vX.X\n" >> $dirname"_vep_script.sge"

	#create folders in 03_VEP_SV_extraction
	echo -e "mkdir -p 03_VEP_SV_extraction/"$dirname"\n" >> $dirname"_vep_script.sge"
	
	#run vep with sample vcf, custom reference annotations,fasta
	echo -e "vep -i "$dirname"/"$dirname"_S_marinoi_v1.1.2.vcf --species phaeodactylum_tricornutum --gff Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene_noFASTA.gff.gz --fasta "$v112_FASTA" --vcf -o 03_VEP_SV_extraction/"$dirname"/"$dirname"_S_marinoi_v1.1.2_vep_out.vcf --fork 8 --offline --cache_version 46 --force_overwrite" >> $dirname"_vep_script.sge"

	#qsub $dirname"_vep_script.sge"	
done
