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
#SBATCH --job-name=refit_exam_3l-ssm

cd $VSC_SCRATCH
cd project2_simulation

module load R
export OMP_NUM_THREADS=1

Rscript refit_exam_3l-ssm.R

