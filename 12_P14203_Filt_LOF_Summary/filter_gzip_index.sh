#!/bin/bash

#André Soares - 22/06/2020

for i in /proj/data9/Loss_of_function_mutations/09_LOF_w_Bamboozle_sv_caller/*/*_lof.vcf; do

        dirname="$(basename "${i}")"
	filename="$(basename $i | cut -d. -f1)"

	#create variables GROUP, QUEUE to feed into pindel and sge files
        spl_no=$(echo $dirname | cut -d '_' -f2)
        if [ "$spl_no" -gt 100 ] && [ "$spl_no" -lt 123 ]; then
#        GROUP="GP2_"$dirname
        QUEUE="high_mem"
        elif [ "$spl_no" -gt 124 ] && [ "$spl_no" -lt 150 ]; then
#        GROUP="VG1_"$dirname
        QUEUE="Annotation-2"
        elif [ "$spl_no" -gt 151 ] && [ "$spl_no" -lt 175 ]; then
#        GROUP="LO_"$dirname
        QUEUE="Annotation-3"
        elif [ "$spl_no" -gt 176 ] && [ "$spl_no" -lt 194 ]; then
#        GROUP="Mutant_"$dirname
        QUEUE="Annotation-1"
        fi;

	#create sge file, feed it the basics
	touch $filename"_script.sge"
	echo -e "#$ -cwd\n#$ -q ""$QUEUE""\n#$ -S /bin/bash\n#$ -pe mpi 1\n" > $filename"_script.sge"
	
	echo "#$ -o /proj/data9/Loss_of_function_mutations/12_P14203_Filt_LOF_Summary/" >> $filename"_script.sge"
        echo -e "#$ -e /proj/data9/Loss_of_function_mutations/12_P14203_Filt_LOF_Summary/\n" >> $filename"_script.sge"

	echo -e "module load snpEff/v.4.3t\nmodule load Java/v1.8.0_191\n" >> $filename"_script.sge"

#	v112_FASTA="/proj/data26/Skeletonema_marinoi_genome_project/12_remove_redundancy/Fake_Primary_Removal/Smar_v1.1.2.fasta"
	v112_GFF="/proj/data26/Skeletonema_marinoi_genome_project/03_Annotation/Skeletonema_marinoi_Ref_v1.1_Primary/Unique_models_per_locus_ManualCuration/Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene.gff"
#	PILON_REF="/proj/data9/Loss_of_function_mutations/05_PilonAssembly_v_v112/P8511_101_gatk/P8511_101_sorted_rdgrp_nodups_fixmate_svcalls.vcf"

	echo -e "cat "$i" | java -jar /usr/local/packages/snpEff/SnpSift.jar filter \"(( QUAL >= 100 ) && (DP >= 30))\" > "$filename"_filt.vcf\n" >> $filename"_script.sge"

	echo -e "bgzip "$filename"_filt.vcf && tabix -p vcf "$filename"_filt.vcf.gz" >> $filename"_script.sge"

	qsub $filename"_script.sge"

done

#MERGE
#INDEX

#python /home/andre/Bamboozle/scripts/lof_utility.py \
#	-v merged_indexed.vcf.gz \
#	-g /proj/data26/Skeletonema_marinoi_genome_project/03_Annotation/Skeletonema_marinoi_Ref_v1.1_Primary/Unique_models_per_locus_ManualCuration/Skeletonema_marinoi_Ref_v1.1_Primary.OnemRNAPerGene.gff \
#	-o LOVIS \
#	-p pop1.txt \
#	-p pop2.txt
