#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=64GB
#SBATCH --cpus-per-task=12
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J fmriprep_SLIP2

set -eu
# Get arguments from submit_job_array.sh
base=$1
study=$2
args=($@)
subjs=(${args[@]:2})
sub=${subjs[${SLURM_ARRAY_TASK_ID}]}
echo $sub

# Define scratch, derivatives, and container paths for convenience
scratch=/scratch/jsein/BIDS/temp_data_${study}
mkdir -p $scratch

singularity run -B /scratch/jsein/BIDS:/work,$HOME/.templateflow:/opt/templateflow --cleanenv /scratch/jsein/my_images/fmriprep-20.2.6.simg \
		 --fs-license-file /work/freesurfer/license.txt /work/$study /work/$study/derivatives  \
		 participant --participant-label $sub \
		 -w /work/temp_data_${study}\
		 --mem-mb 50000 --omp-nthreads 10 --nthreads 12  \
		 --fd-spike-threshold 0.5 --dvars-spike-threshold 2.0 --bold2t1w-dof 9 -t SLIP  \
		 --output-spaces MNI152NLin2009cAsym --ignore slicetiming sbref --debug compcor --return-all-components --bids-filter-file /work/$study/code/fmriprep/bids_filter.json

#--bids-filter-file /work/$study/code/fmriprep/bids_filter.json
