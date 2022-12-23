#!/bin/bash
#!/bin/bash
#SBATCH --mail-type=ALL 			# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH -p skylake
#SBATCH --mail-user=julien.sein@univ-amu.fr	# Your email address
#SBATCH -A b163
##SBATCH --nodes=1					# OpenMP requires a single node
#SBATCH --mem=64gb
#SBATCH --cpus-per-task=12
####SBATCH --ntasks=1					# Run a single serial task
#SBATCH --time=50:00:00				# Time limit hh:mm:ss
#SBATCH -e ./%N.%j.%a.err			# Standard error
#SBATCH -o ./%N.%j.%a.out			# Standard output
#SBATCH -J denoiser_EcritApp_MNIPedia		# Descriptive job name

#SBATCH --mail-type=BEGIN,END
#### END OF JOB DEFINITION  #####

study=AudioDisc
EXPDIR=/scratch/jsein/BIDS/$study
list=$(ls -d $EXPDIR/sub*)
list_sub=${list//"$EXPDIR/sub-"}
list_sub='03 08'
#list_sub='008 009 010 011 012 013 014 015 016 017 018 020 021 022 023 024 025 031 032 033'
#list_sub=$(ls $EXPDIR/derivatives/fmriprep/*.html)
#list_sub=$(echo ${list_sub//"$EXPDIR/derivatives/fmriprep/"})
#list_sub=$(echo ${list_sub//".html"})
#list_sub=$(echo ${list_sub//"sub-"})
#list_sub=$(echo ${list_sub//"001 005 006 007 008 010 011 012"})

output_name=denoiserMNI2009_acompcor12_24HMP_cosine

## test 35 parameters from xcp engine design file 36p:
#tsv_confounds='global_signal global_signal_derivative1 global_signal_derivative1_power2 global_signal_power2  trans_x	trans_x_derivative1	trans_x_power2	trans_x_derivative1_power2	trans_y	trans_y_derivative1	trans_y_power2 trans_y_derivative1_power2 trans_z trans_z_derivative1 trans_z_derivative1_power2 trans_z_power2 rot_x rot_x_derivative1 rot_x_power2 rot_x_derivative1_power2 rot_y rot_y_derivative1 rot_y_power2 rot_y_derivative1_power2 rot_z rot_z_derivative1 rot_z_derivative1_power2 rot_z_power2 a_comp_cor_104 a_comp_cor_105 a_comp_cor_106 a_comp_cor_107 a_comp_cor_108 a_comp_cor_120 a_comp_cor_121 a_comp_cor_122 a_comp_cor_123 a_comp_cor_124 motion_outlier00'
## pipeline : pipeline-24HMP_aCompCor_SpikeReg_4GS from fmridenoise:
tsv_confounds_24HMP='trans_x trans_y trans_z rot_x rot_y rot_z trans_x_derivative1 trans_y_derivative1 trans_z_derivative1 rot_x_derivative1 rot_y_derivative1 rot_z_derivative1 trans_x_power2 trans_y_power2 trans_z_power2 rot_x_power2 rot_y_power2 rot_z_power2'
#global_signal global_signal_derivative1 global_signal_power2
#physio_confounds='csf csf_derivative1 csf_power2 csf_derivative1_power2 white_matter white_matter_derivative1 white_matter_derivative1_power2 white_matter_power2'
#physio_confounds='csf white_matter'
physio_confounds=

mkdir -p $EXPDIR/derivatives/$output_name
for sub in $list_sub
do
	list_func=$(ls $EXPDIR/derivatives/fmriprep/sub-${sub}/func/sub-${sub}*audiodisc*_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz)
	for func in $list_func
	do
		func=$(basename $func)
		base_func=${func/_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz}
		regressor_tsv="${base_func}_desc-confounds_timeseries.tsv"
		regressor_json="$EXPDIR/derivatives/fmriprep/sub-${sub}/func/${base_func}_desc-confounds_timeseries.json"
		acompcor_list=$(python get_compcor.py $regressor_json)
		acompcor_list=$(echo "${acompcor_list//"'"/}")
		acompcor_list=$(echo "${acompcor_list//"["/}")
		acompcor_list=$(echo "${acompcor_list//"]"/}")
		acompcor_list=$(echo "${acompcor_list//","/}")
		#cosine_list=$(python get_cosine.py "$EXPDIR/derivatives/fmriprep/sub-${sub}/func/$regressor_tsv")
		#cosine_list=$(echo "${cosine_list//"'"/}")
		#cosine_list=$(echo "${cosine_list//"["/}")
		#cosine_list=$(echo "${cosine_list//"]"/}")
		#cosine_list=$(echo "${cosine_list//","/}")	
		cosine_list=
		#tsv_confounds="$tsv_confounds_base $acompcor_list" #24MP + 12 acompcor
		tsv_confounds="$physio_confounds $tsv_confounds_24HMP $acompcor_list $cosine_list" #26acompcor only

## default from denoise.sh : csf white_matter std_dvars framewise_displacement trans_x trans_y trans_z rot_x rot_y rot_z 

		python /scratch/jsein/Softs/denoiser/run_denoise.py --col_names $tsv_confounds --out_figure_path $EXPDIR/derivatives/figures_${output_name}  \
		  $EXPDIR/derivatives/fmriprep/sub-${sub}/func/$func \
		  $EXPDIR/derivatives/fmriprep/sub-${sub}/func/$regressor_tsv \
		  $EXPDIR/derivatives/$output_name --hp_filter .008  \
		   ##--lp_filter .08 --hp_filter .008
	done
done