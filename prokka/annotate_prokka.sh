#!/bin/bash

###### Select resources #####
#PBS -N Annotate
#PBS -l select=1:ncpus=64

#### Output File #####
#PBS -o Output/Annotate/Annotate.out

#### Error File #####
#PBS -e Output/Annotate/Annotate.err

##### Queue #####
#PBS -q std

##### Load modules #####
module load prokka

##### Change to current working directory #####
cd /gpfs1/scratch/justine/bacterial_isolates/

##### Make output folder
mkdir -p Output/Annotate/

#### Execute ncbi-genome-download
for INPUT in data/fasta/*
do
    LABEL=$(echo $INPUT | cut -d"/" -f3 | sed "s/.fna//" | sed "s/.fasta//")
    prokka --force --prefix $LABEL --outdir data/gff --cpus 64 --rfam $INPUT
done

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