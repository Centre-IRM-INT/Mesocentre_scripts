#!/bin/bash

# Submit subjects to be run through MRIQC. 

# Usages:

# - run all subjects in project base

# bash submit_job_bidsonym.sh


study=SLIP2
#subjs=$@
subjs='01'
ses='01'
part='group'


# SET THIS TO BE THE PATH TO YOUR BIDS DIRECTORY
bids=/scratch/jsein/BIDS/$study


sbatch $bids/code/bidsonym/ss_bidsonym.sh $bids $study $part $ses ${subjs[@]}
