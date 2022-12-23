#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=32GB
#SBATCH --cpus-per-task=8
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J smriprep_Aging

set -eu
# Get arguments from submit_job_array.sh
base=$1
study=$2
args=($@)
subjs=(${args[@]:2})
sub=${subjs[${SLURM_ARRAY_TASK_ID}]}
echo $sub


singularity run -B /scratch/jsein/BIDS:/work,$HOME/.templateflow:/opt/templateflow --cleanenv /scratch/jsein/my_images/smriprep-0.9.2.simg \
		 --fs-license-file /work/freesurfer/license.txt /work/$study /work/$study/derivatives/smriprep  \
		 participant --participant-label $sub \
		 -w /work/temp_data_${study}\
		 --mem-gb 32 --omp-nthreads 6 --nthreads 8 \
		 --output-spaces T1w MNI152NLin2009cAsym

		 # --topup-max-vols 2 --skip_bids_validation --bids-filter-file --bids-filter-file /work/$study/code/fmriprep/bids_filter.json --use-syn-sdc --force-syn  --output-spaces MNI152NLin2009cAsym
# --output-spaces MNI152NLin2009cAsym MNI152NLin6Asym T1w 