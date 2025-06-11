#!/bin/bash -l

module use /apps/leuven/rocky8/icelake/2021a/modules/all
module load worker/1.6.12-foss-2021a-wice
wsub -batch sim_3l-lmm_all.slurm -data sim_3l-lmm_all_pars.csv