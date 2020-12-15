# Loss-of-function mutations data analysis repository

Gothenburg University - 18/12/2020

 **Author**: André Soares

 - Mats Töpel Research Group

## Organization of the repository

 - `00_Data`:

	- trimmed FASTQs for P14203

 - `01_Mapping`:

	- mapping outputs for P14203 (`00_Data`, SAM and BAM files deleted, sorted BAMs kept)

 - `01_Mapping_Lov`:

	- mapping outputs for P8352 (`/proj/data17/Skeletonema_marinoi_adaptation_to_warming_project/00_data/Trimmed/`, SAM and BAM files deleted, sorted BAMs kept)

 - `02_SV_calling_breakdancer`:

	- test folder for [breakdancer](https://github.com/genome/breakdancer) - abandoned

 - `02_SV_calling_cnvnator`:

	- test folder for [cnvnator](https://github.com/abyzovlab/CNVnator) - abandoned

 - `02_SV_calling_delly`:

	- test folder for [delly](https://github.com/dellytools/delly) - abandoned

 - `02_SV_calling_GRIDSS`:

	- test folder for [GRIDSS](https://github.com/PapenfussLab/gridss) - abandoned

 - `02_SV_calling_lumpy`:

	- test folder for [lumpy](https://github.com/arq5x/lumpy-sv) - abandoned

 - `02_SV_calling_Pindel`:

	- test folder for [pindel](http://gmt.genome.wustl.edu/packages/pindel/) - abandoned

 - `02_SV_calling_Pindel_Lov`:

	- test folder for [pindel](http://gmt.genome.wustl.edu/packages/pindel/) - abandoned

 - `02_SV_calling_sve`:

	- test folder for [sve](https://github.com/TheJacksonLaboratory/SVE) - abandoned

 - `03_SV_calling_stats`:

	- processing of  `pindel` outputs - abandoned

 - `04_SV_extraction`:

	- annotation of `pindel` outputs with [`SnpEff`](https://pcingola.github.io/SnpEff/) - abandoned

 - `05_PilonAssembly_v_v112`:

	- mapping (`05_PilonAssembly_v_v112/map_P8511_101`) and [SVCaller](https://github.com/topel-research-group/Bamboozle/blob/master/modules/sv_caller.py) processing (`P8511_101_gatk`) of P8511 (`/proj/data21/Skeletonema_marinoi/Genome/RO5/A.Blomberg_17_16-P8511/01-QC/P8511_101/fastq_trimmed/`), containing reads used to correct the *S. marinoi* assembly.

 - `06_SV_Pindel_Pilon-Mskd`:

	- processing of P8511-masked `pindel` outputs from P14203 - abandoned

 - `06_SV_Pindel_Pilon-Mskd_Lov`:

	- processing of P8511-masked `pindel` outputs from P8352 - abandoned

 - `07_D_PilonMskd_SV_extraction`:

	- `SnpEff` annotation of P8511-masked `pindel` outputs from P14203 - abandoned

 - `07_D_PilonMskd_SV_extraction_Lov`:

	- `SnpEff` annotation of P8511-masked `pindel` outputs from P8352 - abandoned

 - `08_D_Mskd_Ann_LOF_Data_Analysis_Lov``:

	-  analysis of `07_D_PilonMskd_SV_extraction_Lov` (P8352) outputs - abandoned

 - `09_LOF_w_Bamboozle_sv_caller`:

	- P14203 mapping outputs (`01_Mapping`) processed by SVCaller

 - `10_Lovisa_LOF_Bamboozle`:

	- P8352 mapping outputs (`01_Mapping_Lov`) processed by SVCaller

 - `11_Lovisa_Filt_LOF_Summary`:

	- P8352 [SVCaller](https://github.com/topel-research-group/Bamboozle/blob/master/modules/sv_caller.py) outputs (`10_Lovisa_LOF_Bamboozle`) processed by [lof_utility.py](https://github.com/topel-research-group/Bamboozle/blob/master/scripts/lof_utility.py) and [std_q_g_filter.py](https://github.com/topel-research-group/Bamboozle/blob/master/scripts/std_q_g_filter.py) via `11_Lovisa_Filt_LOF_Summary/merge_filter_q_zyg_utility.sge`

 - `12_P14203_Filt_LOF_Summary`:

	- P14203 [SVCaller](https://github.com/topel-research-group/Bamboozle/blob/master/modules/sv_caller.py) outputs (`10_Lovisa_LOF_Bamboozle`) processed by [lof_utility.py](https://github.com/topel-research-group/Bamboozle/blob/master/scripts/lof_utility.py) and [std_q_g_filer.py](https://github.com/topel-research-group/Bamboozle/blob/master/scripts/std_q_g_filter.py) via `11_Lovisa_Filt_LOF_Summary/merge_filter_q_zyg_utility.sge`

 - `13_P16216_sv_caller`:

	- P16216 mapping outputs (`/proj/data17/Skeletonema_marinoi_adaptation_to_warming_project/01_mapping/v1.1.2/`) processed by [SVCaller](https://github.com/topel-research-group/Bamboozle/blob/master/modules/sv_caller.py)

- `14_P16216_Filt_LOF_Summary`:

	- P16216 [SVCaller](https://github.com/topel-research-group/Bamboozle/blob/master/modules/sv_caller.py) outputs (`10_Lovisa_LOF_Bamboozle`) processed by [lof_utility.py](https://github.com/topel-research-group/Bamboozle/blob/master/scripts/lof_utility.py) and [std_q_g_filter.py](https://github.com/topel-research-group/Bamboozle/blob/master/scripts/std_q_g_filter.py) via `11_Lovisa_Filt_LOF_Summary/merge_filter_q_zyg_utility.sge`
