#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=32GB
#SBATCH --cpus-per-task=12
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J assemblynet

set -eu
# Get arguments from submit_job_array.sh
study=test_assemblynet
#subjs=$@
sub=01
ses=01
echo $sub

# Define scratch, derivatives, and container paths for convenience
scratch=/scratch/jsein/BIDS/temp_data_${study}
mkdir -p $scratch

singularity run -B /scratch/jsein/BIDS/test_assemblynet:/data  \
		 --cleanenv /scratch/jsein/my_images/assemblynet.simg  \
		 /data/sub-08_T1w.nii.gz 
	


