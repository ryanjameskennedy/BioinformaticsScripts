#!/bin/bash

###### Select resources #####
#PBS -N ANI
#PBS -l select=1:ncpus=1

#### Output File #####
#PBS -o /gpfs1/scratch/ryan/bacterial_isolates/novel_isolates/Output/ANI/ANI.^array_index^.out

#### Error File #####
#PBS -e /gpfs1/scratch/ryan/bacterial_isolates/novel_isolates/Output/ANI/ANI.^array_index^.err

##### Queue #####
#PBS -q std

##### Array Details #####
#PBS -J 1-15

##### Load modules #####
# Use your miniconda
source /gpfs1/scratch/ryan/miniconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/ryan/miniconda3/envs/ani/bin:$PATH
export LD_LIBRARY_PATH=/gpfs1/scratch/ryan/miniconda3/envs/ani/lib:$LD_LIBRARY_PATH

conda activate ani

##### Change to current working directory #####
cd /gpfs1/scratch/ryan/bacterial_isolates/novel_isolates

##### Make output folder
mkdir -p Output/ANI

##### Execute ANI array #####
ISOLATE=$(ls | grep -v -e Output -e ARISO138 -e ARISO258 -e ARISO548 -e ARISO703 -e ARISO889 -e ARISO891 | head -n $PBS_ARRAY_INDEX | tail -n 1)
QUERY=$ISOLATE/filepaths/genome_fpaths.txt
#QUERYNAME=$(echo $QUERY | awk -F'/' '{print $(NF)}' | sed 's/.fna//' | sed 's/.fasta//' )
REF=$ISOLATE/filepaths/genome_fpaths.txt
#REFNAME=$(echo $REF | awk -F'/' '{print $(NF)}' | head -n $PBS_ARRAY_INDEX | tail -n 1)

#fastANI --ql $ISOLATE/filepaths/genome_fpaths.txt --rl $ISOLATE/filepaths/genome_fpaths.txt -o $ISOLATE/2_ani_dddh/ani_results_$ISOLATE.txt
pairwise_orthoani.py -c 1 --ql $QUERY --rl $REF -o $ISOLATE/2_ani_dddh/ani_results_$ISOLATE.txt
#cut_ani_dddh.py -d $ISOLATE/0_data -i $ISOLATE/2_ani_dddh -o $ISOLATE/2_ani_dddh/$ISOLATE.csv
#plot_ani_dddh.R -i $ISOLATE/2_ani_dddh/$ISOLATE.csv -o $ISOLATE/2_ani_dddh/$ISOLATE.png

##########################################
#                                        #
#   Output some useful job information.  #
#                                        #
##########################################

echo ------------------------------------------------------
echo -n 'Job is running on node '; cat $PBS_NODEFILE
echo ------------------------------------------------------
echo PBS: qsub is running on $PBS_O_HOST
echo PBS: originating queue is $PBS_O_QUEUE
echo PBS: executing queue is $PBS_QUEUE
echo PBS: working directory is $PBS_O_WORKDIR
echo PBS: execution mode is $PBS_ENVIRONMENT
echo PBS: job identifier is $PBS_JOBID
echo PBS: job name is $PBS_JOBNAME
echo PBS: node file is $PBS_NODEFILE
echo PBS: current home directory is $PBS_O_HOME
echo PBS: `module list 2>&1`
echo PBS: PATH = $PBS_O_PATH
echo PBS: Array input folder is $ISOLATE
echo ------------------------------------------------------
