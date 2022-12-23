#!/bin/bash
#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
##SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=48gb
#SBATCH --cpus-per-task=24
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=80:00:00				# Time limit hh:mm:ss
#SBATCH -e ./%N.%j.%a.err			# Standard error
#SBATCH -o ./%N.%j.%a.out			# Standard output
#SBATCH -J fmriprep_SLIP_sub_28_12cpu			# Descriptive job name

#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####

study=SENCEnew
list_sub='vNav'

singularity run --cleanenv -B /scratch/jsein/BIDS/SENCEnew:/mnt /scratch/jsein/my_images/cerebellum-parcellation_v2.simg \
		-i /mnt/sub-vNav/anat/sub-vNav_T1w.nii.gz -o /mnt/derivatives/DNN 

		   
