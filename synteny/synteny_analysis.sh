#!/bin/bash

###### Select resources #####
#PBS -N Synteny
#PBS -l select=1:ncpus=16

#### Output File #####
#PBS -o Output/Synteny/Synteny.out

#### Error File #####
#PBS -e Output/Synteny/Synteny.err

##### Queue #####
#PBS -q std

##### Load modules #####
# Use your miniconda
source /gpfs1/scratch/ryan/miniconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/ryan/miniconda3/envs/jcvi/bin:$PATH
export LD_LIBRARY_PATH=/gpfs1/scratch/ryan/miniconda3/envs/jcvi/lib:$LD_LIBRARY_PATH

conda activate jcvi

##### Change to current working directory #####
cd $PBS_O_WORKDIR

##### Make output folder
mkdir -p Output/Synteny/

#### Execute synteny analyses
REF=$(ls data/gff/*.gff | head -n 1)
QUERY=$(ls data/gff/*.gff | tail -n 1)
REF_LABEL=$(echo $REF | cut -d"/" -f3 | sed "s/\.gff//")
QUERY_LABEL=$(echo $QUERY | cut -d"/" -f3 | sed "s/\.gff//")
REF_CDS=$(echo $REF | sed "s/\.gff/.ffn/")
QUERY_CDS=$(echo $QUERY | sed "s/\.gff/.ffn/")
python -m jcvi.formats.gff bed --type=CDS,rRNA,tRNA,misc_RNA,tmRNA $REF -o $REF_LABEL.bed
python -m jcvi.formats.gff bed --type=CDS,rRNA,tRNA,misc_RNA,tmRNA $QUERY -o $QUERY_LABEL.bed
python -m jcvi.formats.fasta format $REF_CDS $REF_LABEL.cds
python -m jcvi.formats.fasta format $QUERY_CDS $QUERY_LABEL.cds
python -m jcvi.compara.catalog ortholog $REF_LABEL $QUERY_LABEL --no_strip_names
#python -m jcvi.graphics.dotplot $REF_LABEL.$QUERY_LABEL.anchors
#python -m jcvi.compara.synteny depth --histogram $REF_LABEL.$QUERY_LABEL.anchors
#python -m jcvi.compara.synteny screen --minspan=30 --simple $REF_LABEL.$QUERY_LABEL.anchors $REF_LABEL.$QUERY_LABEL.anchors.new
#python -m jcvi.graphics.karyotype seqids layout

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
echo Reference: $REF label: $REF_LABEL
echo Query: $QUERY label: $QUERY_LABEL
echo ------------------------------------------------------