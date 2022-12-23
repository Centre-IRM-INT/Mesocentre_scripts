#!/bin/bash
#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
##SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=64gb
#SBATCH --cpus-per-task=8
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=80:00:00				# Time limit hh:mm:ss
#SBATCH -o ./log/%x-%A-%a.out
#SBATCH -e ./log/%x-%A-%a.err
#SBATCH -J omni_TOLD		# Descriptive job name

#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####


study=TestOmni


singularity run -B /scratch/jsein/BIDS/$study:/data -B /scratch/jsein/BIDS/$study/derivatives/omni:/out   \
   /scratch/jsein/my_images/omni.simg pipeline /data /out \
   --participant_label 01



# --del_nodeface no_del --brainextraction bet --bet_frac 0.5  --deface_t2w 
   
