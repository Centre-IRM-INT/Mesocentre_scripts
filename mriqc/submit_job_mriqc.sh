#!/bin/bash

# Submit subjects to be run through MRIQC. 

# Usages:

# - run all subjects in project base

# bash submit_job_mriqc.sh


study=SLIP2
#subjs=$@
subjs='01'
ses='01'  #need to not be empty
part='group'  # no need to change this anymore, both participant and group are run now


# SET THIS TO BE THE PATH TO YOUR BIDS DIRECTORY
bids=/scratch/jsein/BIDS/$study


sbatch $bids/code/mriqc/ss_mriqc.sh $bids $study $part $ses ${subjs[@]}
