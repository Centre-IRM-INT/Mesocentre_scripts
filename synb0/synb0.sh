#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=48GB
#SBATCH --cpus-per-task=8
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J synB0_Rennes


#sbatch synb0.sh

study=TOLD

singularity run -e \
-B /scratch/jsein/BIDS/$study/sourcedata/synb0/INPUTS:/INPUTS \
-B /scratch/jsein/BIDS/$study/derivatives/synb0:/OUTPUTS \
-B /scratch/jsein/BIDS/freesurfer/license.txt:/extra/freesurfer/license.txt \
/scratch/jsein/my_images/synb0-disco.simg 

#--stripped



