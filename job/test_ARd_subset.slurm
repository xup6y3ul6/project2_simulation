#!/bin/bash -l
#SBATCH --account=lp_ppw_okp
#SBATCH --cluster=wice
#SBATCH --partition=batch_icelake
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=4
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=All
#SBATCH --mail-user=tzu-yao.lin@kuleuven.be
#SBATCH --output=log/%x_%A_%a.out
#SBATCH --error=log/%x_%A_%a.err
#SBATCH --job-name=test_ARd_subset
cd $VSC_DATA
cd project2_simulation

module load R
export OMP_NUM_THREADS=1
Rscript run_sim_3l-lmm_all.R $model_name $N $D $M $seed $ARd
