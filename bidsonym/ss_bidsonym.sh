#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p kepler
#SBATCH --gres=gpu:2
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=8
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J bidsonym_SLIP2

set -eu
# Get arguments from submit_job_array.sh
args=($@)
subjs="${args[@]:4}"
base=$1
study=$2
part=$3
ses=$4



singularity run -B /scratch/jsein/BIDS/$study:bids_dataset  --nv  \
   /scratch/jsein/my_images/bidsonym-v0.0.5.simg \
   /bids_dataset \
   participant  --deid pydeface --brainextraction nobrainer  \
  --participant_label $subjs --deface_t2w

#--deface_t2w bidsonym-v0.0.4.simg
#pydeface mridefacer 