#!/bin/bash

#André Soares - 02/04/2020

touch gene_summary_P8352_by_group.txt

for i in P*/*summary.genes.txt; do

        #dirname for sample name
        dirname="$(basename "${i}")"
	
        SPL_dir=${i%.vcf.gz}
        SPL_name=${SPL_dir##*/}
        SPL_full=${SPL_name%.*}
        SPL=$(echo $SPL_full | cut -f-2 -d$'_')
	
        genes=$(grep -v "#" $i | cut -f1 -d$'\t')
	
	spl_no=$(echo $dirname | cut -d '_' -f2)
        if [ "$spl_no" -gt 100 ] && [ "$spl_no" -lt 112 ]; then
        SITE="Control_2000"
        elif [ "$spl_no" -gt 113 ] && [ "$spl_no" -lt 124 ]; then
        SITE="Lovisa_2000"
        elif [ "$spl_no" -gt 125 ] && [ "$spl_no" -lt 136 ]; then
        SITE="Control_1960"
        elif [ "$spl_no" -gt 137 ] && [ "$spl_no" -lt 150 ]; then
        SITE="Lovisa_1960"
        fi;

        no_eff=$(echo "$genes" | wc -l)
#       echo $no_eff
        metadata=$(for i in $(seq 1 $no_eff);do echo $SITE; done)

        echo "$genes" > genes_temp
        echo "$metadata" > sample_temp

        paste sample_temp genes_temp >> gene_summary_P8352_by_group.txt
        rm *_temp
done

sed -i '1s/^/sample\tgenes\n/' gene_summary_P8352_by_group.txt
