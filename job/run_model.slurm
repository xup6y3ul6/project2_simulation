#!/bin/bash -l
#SBATCH --account=lp_ppw_okp
#SBATCH --cluster=wice
#SBATCH --partition=batch_sapphirerapids
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=All
#SBATCH --mail-user=tzu-yao.lin@kuleuven.be

cd $VSC_SCRATCH
cd project2_simulation

module load R
export OMP_NUM_THREADS=1

Rscript run_sim_3l-lmm_or_ssm.R $model_name $N $D $M $phi_d $seed &> job/log/${model_name}_${N}${D}${M}_${phi_d}_${seed}_${SLURM_JOB_ID}.log
