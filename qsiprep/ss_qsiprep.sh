#!/bin/bash
##SBATCH -p gpu
#SBATCH -p volta   #volta, kepler
#SBATCH --gres=gpu:2
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=92gb
#SBATCH --cpus-per-task=16
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J qsiprep_NEMO	# Descriptive job name
#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####

set -eu
# Get arguments from submit_job_array.sh
base=$1
study=$2
args=($@)
subjs=(${args[@]:2})
sub=${subjs[${SLURM_ARRAY_TASK_ID}]}
echo "subject is $sub"
echo "base is $base"
echo "study is $study"

# Define scratch, derivatives, and container paths for convenience
scratch=/scratch/jsein/BIDS/temp_data_${study}
#mkdir -p $scratch


singularity run --cleanenv -B /scratch/jsein/BIDS:/work \
 --nv /scratch/jsein/my_images/qsiprep-0.16.0RC3.sif /work/$study  \
 /work/$study/derivatives/qsiprep_full_concat participant --participant_label $sub     \
 -w /work/temp_data_DWImergenone_${study}  --output-resolution 1.2  --fs-license-file /work/freesurfer/license.txt \
  --eddy-config /work/$study/code/qsiprep/eddy_params.json   \
 --b0-threshold 50 --unringing-method mrdegibbs  --denoise-method dwidenoise  \
 --output-space T1w --template MNI152NLin2009cAsym  --distortion-group-merge none 

 #--dwi-only --denoise-method patch2self  dwidenoise --template MNI152NLin2009cAsym --bids-filter-file /work/$study/code/qsiprep/bids-filter.json
 #--distortion-group-merge average none concat -separate-all-dwis
