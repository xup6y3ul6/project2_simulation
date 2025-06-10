#!/bin/bash -l

module --force purge
module use /apps/leuven/rocky8/icelake/2021a/modules/all
module load worker/1.6.12-foss-2021a
wsub -batch sim_3l-lmm_all.slurm -data sim_3l-lmm_all_pars.csv