#!/bin/bash

#André Soares - 22/06/2020

for i in /proj/data9/Loss_of_function_mutations/01_Mapping/P*/*_sorted.bam; do

	#dirname for sample name
        dirname="$(basename "${i}")"
	filename="$(basename $i .bam)"

	#create variables GROUP, QUEUE to feed into pindel and sge files
        spl_no=$(echo $dirname | cut -d '_' -f2)
        if [ "$spl_no" -gt 100 ] && [ "$spl_no" -lt 128 ]; then
#        GROUP="GP2_"$dirname
	QUEUE="Annotation-1"
        elif [ "$spl_no" -gt 129 ] && [ "$spl_no" -lt 156 ]; then
#        GROUP="VG1_"$dirname
	QUEUE="Annotation-2"
        elif [ "$spl_no" -gt 157 ] && [ "$spl_no" -lt 161 ]; then
#        GROUP="LO_"$dirname
	QUEUE="Annotation-4"
        elif [ "$spl_no" -gt 162 ] && [ "$spl_no" -lt 194 ]; then
#        GROUP="Mutant_"$dirname
	QUEUE="high_mem"
        fi;

	#create sge file, feed it the basics
	touch $filename"_script.sge"
	echo -e "#$ -cwd\n#$ -q ""$QUEUE""\n#$ -S /bin/bash\n#$ -pe mpi 20\n" > $filename"_script.sge"
	
	echo "#$ -o /proj/data9/Loss_of_function_mutations/09_LOF_w_Bamboozle_sv_caller/" >> $filename"_script.sge"
        echo -e "#$ -e /proj/data9/Loss_of_function_mutations/09_LOF_w_Bamboozle_sv_caller/\n" >> $filename"_script.sge"

	echo -e "module load bwa/v0.7.17\nmodule load samtools/v1.9\nmodule load gridss/v2.8.3\nmodule load Bedtools2/v2.27.1\nmodule load snpEff/v.4.3t\nmodule load Java/v1.8.0_191\nmodule load Anaconda3/v2019.10\nmodule load Bowtie2/v2.3.4.3\nmodule load bcftools/v1.10.2" >> $filename"_script.sge"

	echo -e "\nmkdir -p "$filename"\n" >> $filename"_script.sge"

	##Basic files
	#bwa-mem and bowtie2 indices in the same folder
	v112_FASTA="/proj/data26/Skeletonema_marinoi_genome_project/12_remove_redundancy/Fake_Primary_Removal/Smar_v1.1.2.fasta"

	#this GFF should be updated soon by Thomas
	v112_GFF="/proj/data26/Skeletonema_marinoi_genome_project/03_Annotation/Skeletonema_marinoi_Ref_v1.1_Primary/Unique_models_per_locus_ManualCuration/Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene.gff"

	#Pilon_D_REF is a Pilon-corrected assembly (P8511_101) ran through snpEff using "Smarinoi.v112 -c /home/andre/snpEff.config"
	PILON_REF="/proj/data9/Loss_of_function_mutations/05_PilonAssembly_v_v112/gridss_P8511_101/P8511_101_PilonAssemblyExtraReads_sorted_ann.vcf"
	
	echo -e "cd "$filename"\n" >> $filename"_script.sge"
	
	echo -e "python /home/andre/Bamboozle/bamboozle.py lof --bamfile "$i" --snpeffdb Smarinoi.v112 -f "$v112_FASTA" -GFF "$v112_GFF" -t 20 -M "$PILON_REF >> $filename"_script.sge"

	#submit, evil laugh
	qsub $filename"_script.sge"	
done
