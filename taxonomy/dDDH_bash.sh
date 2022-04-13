#!/bin/bash

###### Select resources #####
#PBS -N DDDH
#PBS -l select=1:ncpus=64

#### Output File #####
#PBS -o /gpfs1/scratch/ryan/bacterial_isolates/novel_isolates/Output/DDDH/DDDH.^array_index^.out

#### Error File #####
#PBS -e /gpfs1/scratch/ryan/bacterial_isolates/novel_isolates/Output/DDDH/DDDH.^array_index^.err

##### Queue #####
#PBS -q std

##### Array Details #####
#PBS -J 1-15

##### Load modules #####
# Use your miniconda
source /gpfs1/scratch/ryan/miniconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/ryan/miniconda3/envs/taxonomy/bin:$PATH
export LD_LIBRARY_PATH=/gpfs1/scratch/ryan/miniconda3/envs/taxonomy/lib:$LD_LIBRARY_PATH

conda activate taxonomy

##### Change to working directory #####
cd /gpfs1/scratch/ryan/bacterial_isolates/novel_isolates

##### Make output folder
mkdir -p Output/DDDH/

#### Execute dDDH array #####
ISOLATE=$(ls | grep -v -e Output -e ARISO138 -e ARISO258 -e ARISO548 -e ARISO703 -e ARISO889 -e ARISO891 | head -n $PBS_ARRAY_INDEX | tail -n 1)
mkdir -p $ISOLATE/2_blast/blastdb
for QUERY in $(ls $ISOLATE/0_data)
do
    QUERY_NAME=$(echo $QUERY | cut -d"_" -f1,2 | sed "s/.fasta//")
    mkdir -p $ISOLATE/2_blast/$QUERY_NAME
    #cat $(ls $ISOLATE/0_data/* | grep -v $QUERY) > $ISOLATE/2_blast/db_$ISOLATE.fasta
    #makeblastdb -in $ISOLATE/2_blast/db_$ISOLATE.fasta -dbtype nucl -out $ISOLATE/2_blast/blastdb/$QUERY/blastdb_$ISOLATE
    for REF in $(ls $ISOLATE/0_data)
    do
        REF_NAME=$(echo $REF | cut -d"_" -f1,2 | sed "s/.fasta//")
        if ! test -f $ISOLATE/2_blast/blastdb/$REF_NAME*
        then
            makeblastdb -in $ISOLATE/0_data/$REF -dbtype nucl -out $ISOLATE/2_blast/blastdb/$REF_NAME
        fi
        blastall -p blastn -i $ISOLATE/0_data/$QUERY -d $ISOLATE/2_blast/blastdb/$REF_NAME -m 7 -a 1 -S 3 -e 10 -F 'm D' -b 100000 > $ISOLATE/2_blast/blast_results_$(echo $QUERY_NAME)_$REF_NAME.xml
    done
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
echo PBS: Array input folder is $ISOLATE
echo ------------------------------------------------------