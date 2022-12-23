#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=32GB
#SBATCH --cpus-per-task=4
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J Ants_AudioDisc

#set -eu

# script to Normalize processed files from T1w space to MNI2009cAsym space with AntS, 
# with Lanczos interpolation and 2mm isotopic resolution 
# Julien Sein, julien.sein@univ-amu.fr, February 21st 2022

# Define paths:

################### TO DEFINE BY USER ###################
type='Asym' # choice: 'Asym' or 'Sym'
BASE_DIR=/scratch/jsein/BIDS/AudioDisc
IN_DIR=$BASE_DIR/derivatives/Audiodisc_perm/derivatives/T1_to_template
PREPROC_DIR=$BASE_DIR/derivatives/Audiodisc_perm
TEMPLATE_DIR=$BASE_DIR/derivatives/tpl-MNI2009cAsym
FMRIPREP_DIR=$BASE_DIR/derivatives/fmriprep_2009c${type}
ants="singularity exec -e -B $BASE_DIR,$PREPROC_DIR /scratch/jsein/my_images/ants.simg"
#########################################################


# BASE_DIR: BIDS directory
# PREPROC_DIR: BIDS derivatives directory with processed functional images in T1w space
# TEMPLATE_DIR: Directory with target template image in MNI2009cAsym space used by FMRIPREP
# FMRIPREP_DIR: FMRIPREP output directory

#script itself:


#grab processed subject list
pushd $IN_DIR
list_sub=$(ls sub-* -d)
popd
list_sub=sub-01

for sub in $list_sub;do
	echo "processing sub:$sub ..."
	mkdir -p $PREPROC_DIR/$sub/func
	pushd $IN_DIR/$sub
	list_func=$(ls sub-*.nii)
	popd

	for func in $list_func;do 
		#if [[ "$func" == *_rT1w* ]]; then
		#	echo "it is there" 
		#else
			cp $IN_DIR/$sub/$func $PREPROC_DIR/$sub/func/
			$ants antsApplyTransforms --float --default-value 0  \
			--input $IN_DIR/$sub/$func -d 3 -e 3 \
			--interpolation LanczosWindowedSinc \
			--output $PREPROC_DIR/$sub/func/${func/.nii/_space-MNI152NLin2009c${type}.nii} \
			--reference-image $TEMPLATE_DIR/tpl-MNI152NLin2009cAsym_res-02_T1w.nii.gz \
			-t $FMRIPREP_DIR/$sub/anat/${sub}_from-T1w_to-MNI152NLin2009c${type}_mode-image_xfm.h5

		#fi
	done
done



