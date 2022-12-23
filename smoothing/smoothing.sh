#!/bin/bash
#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
##SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=48gb
#SBATCH --cpus-per-task=16
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=20:00:00				# Time limit hh:mm:ss
#SBATCH -e ./%N.%j.%a.err			# Standard error
#SBATCH -o ./%N.%j.%a.out			# Standard output
#SBATCH -J fmriprep_20_2_0_TPMASCO			# Descriptive job name

#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####

 singularity shell -B /scratch/jsein/BIDS:/home/jsein/data /scratch/jsein/my_images/xcpEngine.simg

source ~/.bash_profile

 cd data/EcritAppPreproc/

 fslmaths sub-001/func/sub-001_task-localizer_bold.nii.gz -kernel gauss 2.1233226 -fmean derivatives/smoothing/sub-001/sub-001_task-localizer_rec-smoothedFSLGauss5mm_bold.nii.gz



		   
