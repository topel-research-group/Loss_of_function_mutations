#!/bin/bash

touch P8352_LOF_stats.txt
echo -e "Sample\tSite\tYear\tLOW\tMODERATE\tHIGH\tMODIFIER\tMOD_LOW\tMOD_MOD\tMOD_HI" > P8352_LOF_stats.txt

for i in /proj/data9/Loss_of_function_mutations/07_D_PilonMskd_SV_extraction_Lov/P*/*.vcf; do
	SPL_dir=${i%.vcf}
	SPL_name=${SPL_dir##*/}
	SPL_full=${SPL_name%.*}
	SPL=$(echo $SPL_full | cut -f-2 -d$'_')

	dirname="$(basename "${i}")"
	spl_no=$(echo $dirname | cut -f2 -d$'_')

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
	
	LOW=$(grep -v "^#" $i | grep -c LOW)
	MODERATE=$(grep -v "^#" $i | grep -c MODERATE)
	HIGH=$(grep -v "^#" $i | grep -c HIGH)
	MODIFIER=$(grep -v "^#" $i | grep -c MODIFIER)
	MOD_LOW=$(grep -v "^#" $i | grep MODIFIER | grep -c LOW)
	MOD_MOD=$(grep -v "^#" $i | grep MODIFIER | grep -c MODERATE)
	MOD_HI=$(grep -v "^#" $i | grep MODIFIER | grep -c HIGH)

	echo -e "$SPL\t$SITE\t$YEAR\t$LOW\t$MODERATE\t$HIGH\t$MODIFIER\t$MOD_LOW\t$MOD_MOD\t$MOD_HI" >> P8352_LOF_stats.txt
done
