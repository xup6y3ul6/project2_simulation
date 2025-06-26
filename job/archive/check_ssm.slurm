#!/bin/bash -l
#SBATCH --account=lp_ppw_okp
#SBATCH --cluster=wice
#SBATCH --partition=batch_icelake
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=5
#SBATCH --cpus-per-task=2
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=All
#SBATCH --mail-user=tzu-yao.lin@kuleuven.be
#SBATCH --job-name=check_ssm

cd $VSC_SCRATCH
cd project2_simulation

module load R
export OMP_NUM_THREADS=1

Rscript run_sim_3l-ssm_check.R $model_name &> job/log/${model_name}_${N}${D}${M}${seed}_${SLURM_JOB_ID}.log
