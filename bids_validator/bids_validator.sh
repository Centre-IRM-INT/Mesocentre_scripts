#!/bin/bash
#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
##SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=48gb
#SBATCH --cpus-per-task=12
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=30:00				# Time limit hh:mm:ss
#SBATCH -e ./%N.%j.%a.err			# Standard error
#SBATCH -o ./%N.%j.%a.out			# Standard output
#SBATCH -J bids_validator_1cpu			# Descriptive job name

#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####

study=Test_Anat



singularity exec -e  -B /scratch/jsein/BIDS/$study /scratch/jsein/my_images/bids-validator-latest.simg  bids-validator /scratch/jsein/BIDS/$study 

