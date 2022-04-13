#!/bin/bash
#     Remarks: A line beginning with # is a comment.
#                    A line beginning with #PBS is a PBS directive.
#              PBS directives must come first; any directives
#                 after the first executable statement are ignored.

###### Select resources #####
#PBS -N BUSCO
#PBS -l select=1:ncpus=32

#### Output File #####
#PBS -o Output/BUSCO/BUSCO.^array_index^.out

#### Error File #####
#PBS -e Output/BUSCO/BUSCO.^array_index^.err

##### Queue #####
#PBS -q std

##### Array Details #####
#PBS -J 1-10

##### Load modules #####
source /gpfs1/scratch/ryan/miniconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/ryan/miniconda3/envs/busco/bin:$PATH
export LD_LIBRARY_PATH=/gpfs1/scratch/ryan/miniconda3/envs/busco/lib:$LD_LIBRARY_PATH

conda activate busco

##### Change to current working directory #####
cd $PBS_O_WORKDIR

##### Make output folder #####
mkdir -p Output/BUSCO/

##### Execute array #####
INPUT=$(ls unfiltered/* | head -n $PBS_ARRAY_INDEX | tail -n 1)
busco -i $INPUT -o busco_unfiltered_$PBS_ARRAY_INDEX --auto-lineage-prok -m genome -c 16

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
echo ------------------------------------------------------
