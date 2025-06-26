#!/bin/bash -l
# submit multiple SLURM jobs

# defined the path of the parameter file
PARAM_FILE="pars.csv"

# delete the first line then read each line of the parameter file
sed 1d $PARAM_FILE | while IFS=, read -r model_name N D M phi_d seed; do
    # print current line
    echo "Submitting job with model_name=$model_name, N=$N, D=$D, M=$M, phi_d=$phi_d, seed=$seed"
    
    # export the local variables to the environmental variables
    export model_name
    export N
    export D
    export M
    export phi_d
    export seed
    
    # submit each Slurm job
    sbatch --job-name="${model_name}${N}${D}${M}${phi_d}"\
           --export=model_name,N,D,M,phi_d,seed\
           run_model.slurm
    sleep 3
done
