#!/bin/bash -l

module use /apps/leuven/rocky8/icelake/2021a/modules/all
module load worker/1.6.12-foss-2021a-wice
wsub --batch test_ARd.slurm --data test_ARd_pars.csv