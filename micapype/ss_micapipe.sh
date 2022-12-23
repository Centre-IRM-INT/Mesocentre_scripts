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
#SBATCH -J micapipe_SLIP

set -eu
# Get arguments from submit_job_array.sh
base=$1
study=$2
ses=$3
args=($@)
subjs=(${args[@]:3})
sub=${subjs[${SLURM_ARRAY_TASK_ID}]}
echo $sub

# Define scratch, derivatives, and container paths for convenience
scratch=/scratch/jsein/BIDS/temp_data_${study}
mkdir -p $scratch

singularity run -B /scratch/jsein/BIDS:/work --cleanenv /scratch/jsein/my_images/micapipe-v0.1.2.simg \
		  -bids /work/$study -out /work/$study/derivatives  \
		 participant -sub $sub -ses $ses -proc_structural -QC_subj  \
		 -tmpDir /work/temp_data_${study}\
		 -threads 12  \
	


#--fs-license-file /work/freesurfer/license.txt