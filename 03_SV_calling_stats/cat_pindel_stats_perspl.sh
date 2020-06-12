#!/bin/bash

#head -n1 P14203_101_S_marinoi_v1.1.2.vcf.gz_data/multiqc_bcftools_stats.txt > P14203_pindel_stats.txt

for i in P*_data/multiqc_bcftools_stats.txt; do
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

	#tail -n1 $i >> P14203_pindel_stats.txt
	#echo "WOOOOOP"
	echo $i
	echo $spl_no
	echo $GROUP
done
