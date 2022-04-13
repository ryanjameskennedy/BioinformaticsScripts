#!/bin/bash

###### Select resources #####
#PBS -N MappingVisualizer
#PBS -l select=1:ncpus=16

#### Output File #####
#PBS -o Output/MappingVisualizer/MappingVisualizer.out

#### Error File #####
#PBS -e Output/MappingVisualizer/MappingVisualizer.err

##### Queue #####
#PBS -q std

##### Load modules #####
# Use your miniconda
source /gpfs1/scratch/ryan/miniconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/ryan/miniconda3/envs/coverage/bin:$PATH
export LD_LIBRARY_PATH=/gpfs1/scratch/ryan/miniconda3/envs/coverage/lib:$LD_LIBRARY_PATH

conda activate coverage
module load bwa
module load samtools

##### Change to current working directory #####
cd $PBS_O_WORKDIR

##### Make output folder
mkdir -p Output/MappingVisualizer/

##### Execute snakemake #####

snakemake --cores 16

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
