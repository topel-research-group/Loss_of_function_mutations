#!/bin/bash

touch P8352_LOF_effects_stats.txt
echo -e "Sample\tSite\tYear\tType\tCount\tPercent" > P8352_LOF_effects_stats.txt

for i in /proj/data9/Loss_of_function_mutations/07_D_PilonMskd_SV_extraction_Lov/P*/*_Mskd_D_summary.csv; do
	SPL_dir=${i%.vcf}
	SPL_name=${SPL_dir##*/}
	SPL_full=${SPL_name%.*}
	SPL=$(echo $SPL_full | cut -f-2 -d$'_')

	dirname="$(basename "${i}")"

        spl_no=$(echo $dirname | cut -d '_' -f2)

        if [ "$spl_no" -gt 100 ] && [ "$spl_no" -lt 112 ]; then
        SITE="Control"
	YEAR="2000"
        elif [ "$spl_no" -gt 113 ] && [ "$spl_no" -lt 124 ]; then
        SITE="Lovisa"
	YEAR="2000"
        elif [ "$spl_no" -gt 125 ] && [ "$spl_no" -lt 136 ]; then
        SITE="Control"
	YEAR="1960"
        elif [ "$spl_no" -gt 137 ] && [ "$spl_no" -lt 150 ]; then
        SITE="Lovisa"
	YEAR="1960"
        fi;
	
	effects1=$(sed -n '/# Count by effects/,/# Count by genomic region/p' $i | tail -n+4 | head -n-2 | sed 's/ , /\t/g' | cut -f1 -d$'\t')
	effects2=$(sed -n '/# Count by effects/,/# Count by genomic region/p' $i | tail -n+4 | head -n-2 | sed 's/ , /\t/g' | cut -f2 -d$'\t')
	effects3=$(sed -n '/# Count by effects/,/# Count by genomic region/p' $i | tail -n+4 | head -n-2 | sed 's/ , /\t/g' | cut -f3 -d$'\t')

	no_eff=$(echo "$effects1" | wc -l)
#	echo $no_eff
	sample=$(for i in $(seq 1 $no_eff);do echo $SPL; done)
	site=$(for i in $(seq 1 $no_eff);do echo $SITE; done)
	year=$(for i in $(seq 1 $no_eff);do echo $YEAR; done)

	echo "$sample" > sample_temp
	echo "$site" > site_temp
	echo "$year" > year_temp
	echo "$effects1" > ef1_temp
	echo "$effects2" > ef2_temp
	echo "$effects3" > ef3_temp
			
	paste sample_temp site_temp year_temp ef1_temp ef2_temp ef3_temp >> P8352_LOF_effects_stats.txt
	sed -e s/%//g -i P8352_LOF_effects_stats.txt
	rm *_temp
done
