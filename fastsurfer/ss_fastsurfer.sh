#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p volta
#SBATCH --gres=gpu:2
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=92GB
#SBATCH --cpus-per-task=16
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J fastsurfer_SLIP2

set -eu
# Get arguments from submit_job_array.sh
bids=$1
study=$2
option=$3
args=($@)
subjs=(${args[@]:3})
sub=${subjs[${SLURM_ARRAY_TASK_ID}]}
echo $sub

mkdir -p $base/derivatives/fastsurfer_${option}

singularity exec --nv -B $bids:/data \
                      -B $bids/derivatives/fastsurfer_${option}:/output \
                      -B /scratch/jsein/BIDS/freesurfer:/fs \
                       /scratch/jsein/my_images/fastsurfer-gpu.sif \
                       /fastsurfer/run_fastsurfer.sh \
                      --fs_license /fs/license.txt \
                      --t1 /data/sub-${sub}/anat/sub-${sub}_acq-${option}_T1w.nii.gz \
                      --sid sub-${sub} --sd /output \
                      --parallel