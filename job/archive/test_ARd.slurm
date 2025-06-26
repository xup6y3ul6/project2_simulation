#!/bin/bash -l
#SBATCH --account=lp_ppw_okp
#SBATCH --cluster=wice
#SBATCH --partition=batch_icelake
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=25
#SBATCH --cpus-per-task=2
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=All
#SBATCH --mail-user=tzu-yao.lin@kuleuven.be
#SBATCH --job-name=test_ARd

cd $VSC_SCRATCH
cd project2_simulation

module load R
export OMP_NUM_THREADS=1

Rscript run_sim_3l-lmm_all.R $model_name $N $D $M $seed $ARd &> job/log/${model_name}_${N}${D}${M}${ARd}${seed}_${SLURM_JOB_ID}.log
