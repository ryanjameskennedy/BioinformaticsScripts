#!/bin/bash
#     Remarks: A line beginning with # is a comment.
#                    A line beginning with #PBS is a PBS directive.
#              PBS directives must come first; any directives
#                 after the first executable statement are ignored.

###### Select resources #####
#PBS -N BACTERIA
#PBS -l select=1:ncpus=64

#### Output File #####
#PBS -o /gpfs1/scratch/justine/bacterial_isolates/Output/FASTANI/FASTANI.^array_index^.out

#### Error File #####
#PBS -e /gpfs1/scratch/justine/bacterial_isolates/Output/FASTANI/FASTANI.^array_index^.err

##### Queue #####
#PBS -q std

##### Array Details #####
#PBS -J 1-110

##### Load modules #####
# Use your miniconda
source /gpfs1/scratch/ryan/miniconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/ryan/miniconda3/envs/ani/bin:$PATH
export LD_LIBRARY_PATH=/gpfs1/scratch/ryan/miniconda3/envs/ani/lib:$LD_LIBRARY_PATH

conda activate ani

##### Change to current working directory #####
cd /gpfs1/scratch/justine/bacterial_isolates

##### Execute array #####
mkdir -p Output/FASTANI/
ISOLATE=$(ls | grep -v -e Output | head -n $PBS_ARRAY_INDEX | tail -n 1)
REF=/gpfs1/scratch/ryan/bacterial_db_fpaths.txt
fastANI -q $ISOLATE/0_data/$ISOLATE.fasta --rl $REF -o $ISOLATE/2_ani_dddh/fastani_results_$ISOLATE.txt

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
echo PBS: Array input file is $NAME
echo ------------------------------------------------------



