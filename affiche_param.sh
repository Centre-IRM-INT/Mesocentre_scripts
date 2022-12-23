#!/bin/bash
# affiche_param.sh

set -eu

#args=($@)
#subjs="${args[@]:2}"
#base=$1
#study=$2
#part=$3
#ses=$4

set -eu
# Get arguments from submit_job_array.sh
base=$1
study=$2
part=$3
ses=$4
args=($@)
subjs=(${args[@]:4})
#sub=${subjs[${SLURM_ARRAY_TASK_ID}]}



echo "Le 1er paramètre est : $base"
echo "study est: $study"
#echo "part est: $part"
#echo "ses est: $ses"
echo "liste des sujets est $subjs" 
echo "Le sujet 1 est ${subjs[0]}"
echo "Le sujet 2 est ${subjs[1]}"
echo "Le sujet 3 est ${subjs[2]}"
echo "Le sujet 4 est ${subjs[3]}"