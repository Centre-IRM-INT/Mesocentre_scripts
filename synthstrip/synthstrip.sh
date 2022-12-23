#!/bin/bash
#!/bin/bash



#!/bin/bash
##SBATCH -p gpu
#SBATCH -p kepler
#SBATCH --gres=gpu:2
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=28gb
#SBATCH --cpus-per-task=12
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J Synthstrip_Aging	# Descriptive job name
#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####


module load userspace/all
module load PGI/14.9
#pgf90 -Mpreprocess -DGPUID=$CUDA_VISIBLE_DEVICES -fast -o exec exec.cuf

#./exec

study=Covoprim
EXPDIR=/scratch/jsein/BIDS/$study
OUTDIR=
sub='Musly'
OUTDIR=/scratch/jsein/BIDS/$study/derivatives/synthstrip/sub-${sub}/ses-anat/anat/
mkdir -p $OUTDIR

/scratch/jsein/my_images/synthstrip-singularity -i $EXPDIR/sub-${sub}/ses-anat/anat/sub-${sub}_ses-anat_run-01_T1w.nii.gz -o $OUTDIR/sub-${sub}_ses-anat_run-01_T1w_brain.nii.gz -m $OUTDIR/sub-${sub}_ses-anat_T1w_brain_mask.nii.gz 

