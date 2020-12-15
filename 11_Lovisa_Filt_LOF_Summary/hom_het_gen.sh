#!/bin/bash

#André Soares - 22/06/2020

for i in *.vcf; do

	#create sge file, feed it the basics
	touch $i"_script.sge"
	echo -e "#$ -cwd\n#$ -q high_mem\n#$ -S /bin/bash\n#$ -pe mpi 1\n" > $i"_script.sge"
	
	echo -e "module load snpEff/v.4.3t\nmodule load Java/v1.8.0_191\n" >> $i"_script.sge"

	echo -e "python /home/andre/Bamboozle/scripts/std_q_g_filter.py -v "$i >> $i"_script.sge"

	qsub $i"_script.sge"

done
