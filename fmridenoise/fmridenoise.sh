#!/bin/bash
#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
#SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=24gb
#SBATCH --cpus-per-task=8
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=10:00:00				# Time limit hh:mm:ss
#SBATCH -e ./%N.%j.%a.err			# Standard error
#SBATCH -o ./%N.%j.%a.out			# Standard output
#SBATCH -J fmridenoise_AudioDisc_skylake			# Descriptive job name
#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####

study=AudioDisc
list_sub='pilote4'


fmridenoise compare -t audiodisc -sub $list_sub -p pipeline-24HMP_aCompCor_SpikeReg pipeline-24HMP_aCompCor_SpikeReg_4GS /scratch/jsein/BIDS/$study

# pipeline-24HMP_aCompCor_SpikeReg
#pipeline-24HMP_aCompCor_SpikeReg_4GS