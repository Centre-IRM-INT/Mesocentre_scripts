#!/bin/bash
##SBATCH -p gpu
#SBATCH -p volta
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
#SBATCH -J qsirecon_EcriPark	# Descriptive job name

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


singularity run  -B /scratch/jsein/BIDS:/work,$HOME/.templateflow:/home/qsiprep/.cache/templateflow \
 /scratch/jsein/my_images/qsiprep-0.18.0.sif /work/$study  \
 /work/$study/derivatives participant --participant_label $sub     \
 -w /work/temp_data_pyafq_${study}  --fs-license-file /work/freesurfer/license.txt \
 --recon-only --recon-spec mrtrix_multishell_msmt_pyafq_tractometry  --recon-input /work/$study/derivatives/qsiprep \
 --freesurfer-input /work/$study/derivatives/fmriprep/sourcedata/freesurfer  

 #--skip-odf-reports     mrtrix_multishell_msmt_ACT-hsvs   mrtrix_singleshell_ss3t_ACT-hsvs  --stop-on-first-crash
 # mrtrix_multishell_msmt_pyafq_tractometry --nv


