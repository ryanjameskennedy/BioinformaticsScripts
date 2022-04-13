#!/bin/bash

###### Select resources #####
#PBS -N Annotate
#PBS -l select=1:ncpus=64

#### Output File #####
#PBS -o /gpfs1/scratch/ryan/SGAir187/Output/Annotate/Annotate.out

#### Error File #####
#PBS -e /gpfs1/scratch/ryan/SGAir187/Output/Annotate/Annotate.err

##### Queue #####
#PBS -q std

##### Load modules #####
module load prodigal
module load python3
module load java/openjdk/11.0.7
module load perl

##### Change to current working directory #####
cd /gpfs1/scratch/ryan/SGAir187/

##### Make output folder
mkdir -p Output/Annotate/

#### Execute InterProScan
for INPUT in data/fasta/*
do
    LABEL=$(echo $INPUT | cut -d"/" -f3 | sed "s/.fna//" | sed "s/.fasta//")
    prodigal -i $INPUT -f gbk -o data/gbk/$LABEL.gbk -a data/faa/$LABEL.faa -d data/cds/$LABEL.cds
    interproscan.sh -i data/faa/$LABEL.faa -f GFF3 -o data/gff/$LABEL.gff
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