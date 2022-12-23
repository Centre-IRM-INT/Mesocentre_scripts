


study='NEMO'
#list_sub='pilote1 pilote2'
EXPDIR=/scratch/jsein/BIDS/$study
list_sub=$(ls $EXPDIR/derivatives/fmriprep/*.html)
list_sub=$(echo ${list_sub//"$EXPDIR/derivatives/fmriprep/"})
list_sub=$(echo ${list_sub//".html"})
list_sub=$(echo ${list_sub//"sub-"})
list_sub='pilote1 pilote2'

cd $EXPDIR/derivatives
echo "id0,id1,img"> "func_cohort_${study}.csv"
for sub in $list_sub
do
list_func=$(ls fmriprep/sub-${sub}/func/sub-${sub}_task-rest_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz)
for func in $list_func
do 
	task_id=$(echo $func | sed -e 's/.*task-\(.*\)_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz/\1/') 
	echo "sub-${sub},task-${task_id},$func">> "func_cohort_${study}.csv"
done
done
