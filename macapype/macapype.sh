#!/bin/bash
#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
##SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=16gb
#SBATCH --cpus-per-task=12
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=80:00:00				# Time limit hh:mm:ss
#SBATCH -e ./%N.%j.%a.err			# Standard error
#SBATCH -o ./%N.%j.%a.out			# Standard output
#SBATCH -J macapype			# Descriptive job name

#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####

study=PNH_ANAT_IBOS_BIDS

#macapype.simg is macapype:latest from Feb 11th 2021

singularity run -B /scratch/jsein/BIDS/$study:/data/macapype \
 /scratch/jsein/my_images/macapype.simg \
 python /opt/packages/macapype/workflows/segment_pnh.py \
 -soft ANTS -data /data/macapype -out /data/macapype \
 -params /opt/packages/macapype/workflows/params_segment_macaque_ants_based.json

