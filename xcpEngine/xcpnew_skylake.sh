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
#SBATCH -o ./log/%x-%A-%a.out       # Standard output
#SBATCH -e ./log/%x-%A-%a.err		# Standard error		
#SBATCH -J xcp_EcritApp_anat		# Descriptive job name

#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####

study=NEMO
list_sub='pilote1 pilote2'

singularity run -B /scratch/jsein/BIDS/$study/derivatives:/home/jsein/data  \
   /scratch/jsein/my_images/xcpEngine_latest.simg \
   -d /home/jsein/data/fc_acompcor.dsn \
   -c /home/jsein/data/func_cohort_${study}.csv  \
   -o /home/jsein/data/xcp_output \
   -t 1 \
   -r /home/jsein/data
