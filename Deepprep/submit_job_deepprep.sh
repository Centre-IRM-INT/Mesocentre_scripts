#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p volta
#SBATCH --gres=gpu:1
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=48GB
#SBATCH --cpus-per-task=12
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J deepprep_MotorLang



study=MotorLang

sub='28' # uncomment for processing selected subjects EX: subjs=(05 06 07)

# SET THIS TO BE THE PATH TO YOUR BIDS DIRECTORY
bids=/scratch/jsein/BIDS/$study


# uncomment these lines below to grab all subjects

#pushd $bids
#subjs=($(ls sub-* -d))
#popd
# fi

# Define scratch, derivatives, and container paths for convenience
scratch=/scratch/jsein/BIDS/temp_deepprep_${study}
mkdir -p $scratch

#container=/scratch/jsein/my_images/deepprep_23.1.0.sif

export APPTAINERENV_TEMPLATEFLOW_HOME=/opt/templateflow

singularity run --nv -B /scratch/jsein/BIDS:/work,$HOME/.templateflow:/opt/templateflow /scratch/jsein/my_images/deepprep_25.1.0.sif \
 /work/$study /work/$study/derivatives/deepprep \
 participant --participant_label \'sub-${sub}\' \
 --fs_license_file /work/freesurfer/license.txt --skip_bids_validation \
  --device gpu  --bold_task_type Langage --cpus 12 --memory 48 --bold_volume_space MNI152NLin2009cAsym --bold_cifti \
 #--executor cluster --bold_task_type ArchiLocalizer


