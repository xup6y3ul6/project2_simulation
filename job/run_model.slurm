#!/bin/bash -l
#SBATCH --account=lp_ppw_okp
#SBATCH --cluster=wice
#SBATCH --partition=batch_icelake
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=All
#SBATCH --mail-user=tzu-yao.lin@kuleuven.be
#SBATCH --job-name=${model_name}_${phi_d}

cd $VSC_SCRATCH
cd project2_simulation

module load R
export OMP_NUM_THREADS=1

Rscript run_sim_3l-lmm_or_ssm.R $model_name &> job/log/${model_name}_${N}${D}${M}_${phi_d}_${seed}_${SLURM_JOB_ID}.log
