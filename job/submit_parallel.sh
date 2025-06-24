#!/bin/bash -l
# submit multiple SLURM jobs

# defined the path of the parameter file
PARAM_FILE="pars.csv"

# read each line of the parameter file
tail -n +2 $PARAM_FILE | while IFS=, read -r model_name N D M seed; do
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
    sbatch run_model.slurm
done