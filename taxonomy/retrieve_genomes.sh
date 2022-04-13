#!/bin/bash

###### Select resources #####
#PBS -N NCBIGD
#PBS -l select=1:ncpus=64

#### Output File #####
#PBS -o /gpfs1/scratch/justine/bacterial_isolates/Output/NCBIGD/NCBIGD.^array_index^.out

#### Error File #####
#PBS -e /gpfs1/scratch/justine/bacterial_isolates/Output/NCBIGD/NCBIGD.^array_index^.err

##### Queue #####
#PBS -q std

##### Array Details #####
#PBS -J 1-15

##### Load modules #####
# Use your miniconda
source /gpfs1/scratch/justine/miniconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/justine/miniconda3/envs/taxonomy/bin:$PATH
export LD_LIBRARY_PATH=/gpfs1/scratch/justine/miniconda3/envs/taxonomy/lib:$LD_LIBRARY_PATH

conda activate taxonomy

##### Change to working directory #####
cd /gpfs1/scratch/justine/bacterial_isolates

##### Make output folder
mkdir -p Output/NCBIGD/

#### Execute ncbi-genome-download
ISOLATE=$(ls | grep -v -e Output | head -n $PBS_ARRAY_INDEX | tail -n 1)
ncbi-genome-download -s genbank -F fasta -A $ISOLATE/filepaths/accn_list.txt -o $ISOLATE/0_data -p 64 bacteria
mv $ISOLATE/0_data/genbank/bacteria/*/*.gz $ISOLATE/0_data
gunzip $ISOLATE/0_data/*.gz
rm -r $ISOLATE/0_data/genbank/
ls $ISOLATE/0_data/* > $ISOLATE/filepaths/genome_fpaths.txt

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