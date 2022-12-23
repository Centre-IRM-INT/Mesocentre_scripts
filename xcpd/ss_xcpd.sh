#!/bin/bash
#SBATCH --mail-type=ALL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr  # Your email address
#SBATCH -A b163
#SBATCH --nodes=1             # OpenMP requires a single node
#SBATCH --mem=64GB
#SBATCH --cpus-per-task=12
#SBATCH --time=50:00:00          # Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J xcpd_PREDYS

set -eu
# Get arguments from submit_job_array.sh
base=$1
study=$2
args=($@)
subjs=(${args[@]:2})
sub=${subjs[${SLURM_ARRAY_TASK_ID}]}
echo $sub

# Define scratch, derivatives, and container paths for convenience
scratch=/scratch/jsein/BIDS/temp_data21_${study}
mkdir -p $scratch


#export TEMPLATEFLOW_HOME=$HOME/.templateflow


singularity run -B /scratch/jsein/BIDS:/work,$HOME/.templateflow:$HOME/.cache/templateflow  \
   /scratch/jsein/my_images/xcp_d-0.1.3.simg \
   /work/$study/derivatives/fmriprep /work/$study/derivatives \
   participant --participant-label $sub \
   -w /work/temp_data_xcpds0_${study}\
   --mem_gb 50 --omp-nthreads 10 --nthreads 12 -t ArchiLocalizer --smoothing 0   \
   --nuissance-regressors 36P --despike --lower-bpf 0.01 --upper-bpf 0.08 

   #$HOME/.templateflow:$HOME/.cache/templateflow
   #--smoothing 4 --nuissance-regressors acompcor 36P
  

