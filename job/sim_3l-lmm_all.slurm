#!/bin/bash -l
#SBATCH --account=lp_ppw_okp
#SBATCH --cluster=wice
#SBATCH --partition=batch_icelake
#SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=All
#SBATCH --mail-user=tzu-yao.lin@kuleuven.be
#SBATCH --output=log/%x.out
#SBATCH --error=log/%x.err
#SBATCH --job-name=sim_3l-lmm_ARdHdARmHm

module load R

cd $VSC_DATA
cd project2_simulation

# Use the default settings
# > Rscript run_sim_3l-lmm_all.R
# Give additional argument 
# > Rscript run_sim_3l-lmm_all.R <model-name> <N> <D> <S> <Seed> [Sufix]
Rscript run_sim_3l-lmm_all.R sim_3l-lmm_ARdHdARmHm 20 20 20 20250610 
