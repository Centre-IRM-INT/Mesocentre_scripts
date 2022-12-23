#!/bin/bash
#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
##SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=48gb
#SBATCH --cpus-per-task=8
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=80:00:00				# Time limit hh:mm:ss
#SBATCH -e ./%N.%j.%a.err			# Standard error
#SBATCH -o ./%N.%j.%a.out			# Standard output
#SBATCH -J fmriprep_SLIP_sub_28_12cpu			# Descriptive job name

#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####

study=AudioVisAsso
list_sub='pilot2'

BASEDIR=/scratch/jsein/BIDS
EXPDIR=/scratch/jsein/BIDS/$study
SING=/scratch/jsein/my_images/hcp.simg

singularity run --cleanenv -B $BASEDIR:$BASEDIR \
	 $SING $EXPDIR $EXPDIR/derivatives/HCPPipelines \
	 participant --participant_label $list_sub \
	  --license_key Cxm5TXOYiGbE --gdcoeffs $BASEDIR/gradient_DISCOR/coeff_AS82.grad  --n_cpus 8 \
	  --stages PreFreeSurfer FreeSurfer PostFreeSurfer


		   
