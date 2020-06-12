#!/bin/bash

#André Soares - 02/04/2020

touch gene_summary_P8352.txt

for i in P*/*summary.genes.txt; do

        #dirname for sample name
        dirname="$(basename "${i}")"
	
        SPL_dir=${i%.vcf.gz}
        SPL_name=${SPL_dir##*/}
        SPL_full=${SPL_name%.*}
        SPL=$(echo $SPL_full | cut -f-2 -d$'_')
	
        genes=$(grep -v "#" $i | cut -f1 -d$'\t')

        no_eff=$(echo "$genes" | wc -l)
#       echo $no_eff
        sample=$(for i in $(seq 1 $no_eff);do echo $SPL; done)

        echo "$genes" > genes_temp
        echo "$sample" > sample_temp

        paste sample_temp genes_temp >> gene_summary_P8352.txt
        rm *_temp
done

sed -i '1s/^/sample\tgenes\n/' gene_summary_P8352.txt
