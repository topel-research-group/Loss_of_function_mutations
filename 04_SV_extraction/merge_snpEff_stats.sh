#!/bin/bash

echo -e "Sample\tGroup\tEffect\tCount\tPer_Sample_Percent" > P14203_snpEff_summary.txt

for i in /proj/data9/Loss_of_function_mutations/04_SV_extraction/P14203_*/*_summary.csv; do

        #dirname for sample name
        dirname="$(basename "${i}")"

	#create variables GROUP, QUEUE to feed into pindel and sge files
        spl_no=$(echo $dirname | cut -d '_' -f2)
        if [ "$spl_no" -gt 100 ] && [ "$spl_no" -lt 128 ]; then
        GROUP="GP2"
        elif [ "$spl_no" -gt 129 ] && [ "$spl_no" -lt 156 ]; then
        GROUP="VG1"
        elif [ "$spl_no" -gt 157 ] && [ "$spl_no" -lt 161 ]; then
        GROUP="LO"
        elif [ "$spl_no" -gt 162 ] && [ "$spl_no" -lt 194 ]; then
        GROUP="Mutant"
        fi;	

        SPL_dir=${i%.vcf.gz}
        SPL_name=${SPL_dir##*/}
        SPL_full=${SPL_name%.*}
        SPL=$(echo $SPL_full | cut -f-2 -d$'_')

	#echo $SPL
	#echo $dirname
	
	eff_no=$(sed -n -e '/# Count by effects/,/# Count by genomic region/ p' $i | tail -n +4 | head -n -2 | wc -l)
        yes "$SPL" | head -n $eff_no > temp_spl.txt
	yes "$GROUP" | head -n $eff_no > temp_group.txt

	#get stats
	sed -n -e '/# Count by effects/,/# Count by genomic region/ p' $i | tail -n +4 | head -n -2 | tr ',' '\t' > temp_stats.txt
	
	#paste stuff together and append to summary file
	paste -d '\t' temp_spl.txt temp_group.txt temp_stats.txt >> P14203_snpEff_summary.txt

	#remove temp stuff
	rm temp_spl.txt temp_group.txt temp_stats.txt
done

sed 's/%//' P14203_snpEff_summary.txt > P14203_snpEff_summary_clean.txt
