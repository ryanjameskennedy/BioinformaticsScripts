#!/bin/bash
#     Remarks: A line beginning with # is a comment.
#                    A line beginning with #PBS is a PBS directive.
#              PBS directives must come first; any directives
#                 after the first executable statement are ignored.

###### Select resources #####
#PBS -N BWA
#PBS -l select=1:ncpus=32

#### Output File #####
#PBS -o /gpfs1/scratch/akira/job_info/bwa.^array_index^.out

#### Error File #####
#PBS -e /gpfs1/scratch/akira/job_info/bwa.^array_index^.err

##### Queue #####
#PBS -q std

##### Array Details #####
#PBS -J 1-10

##### Load modules #####
# Use your miniconda
module load bwa
module load samtools

##### Change to current working directory #####
cd /gpfs1/scratch/akira

##### Execute array #####
mkdir -p /gpfs1/scratch/akira/job_info/map
FASTA=$(ls | head -n $PBS_ARRAY_INDEX | tail -n 1)
FASTQ=$(ls | head -n $PBS_ARRAY_INDEX | tail -n 1)
SAM=$(echo $FASTA | sed "s/\.fasta/\.sam/" | sed "s/\.fa/\.sam/"| sed "s/\.fna/\.sam/")
BAM=$(echo $SAM | sed "s/\.sam/\.bam/" )
DICT=$(echo $SAM | sed "s/\.sam/\.dict/" )

bwa index $FASTA
bwa mem -M -t 32 $FASTA $FASTQ > $SAM
samtools view -Sb -@ 32 $SAM | samtools sort -@ 32 -o $BAM - 
samtools index -@ 32 $BAM
samtools dict $FASTA -o $DICT

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
echo PBS: Array input file is $FASTA
echo ------------------------------------------------------
