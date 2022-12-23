#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=92GB
#SBATCH --cpus-per-task=16
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J mriqc_SLIP

set -eu
# Get arguments from submit_job_array.sh
args=($@)
subjs="${args[@]:4}"
base=$1
study=$2
part=$3
ses=$4





singularity run --cleanenv -B /scratch/jsein/BIDS:/work \
 /scratch/jsein/my_images/mriqc-21.0.0rc2.simg /work/$study  \
 /work/$study/derivatives/mriqc $part --participant_label $subjs  --n_procs 12    \
   -w /work/temp_data_${study}  --fd_thres 0.5  --verbose-reports  --session-id $ses

   # --ica --run-id 01 --task-id rest -m bold --session-id $ses