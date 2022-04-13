#!/bin/bash

### Job Name
#PBS -N LINEAGE

### Project code
#PBS -l select=1:ncpus=1
#PBS -q std
#PBS -j oe
#PBS -o logs

source /gpfs1/scratch/ryan/miniconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/ryan/miniconda3/envs/lineage/bin:$PATH
export LD_LIBRARY_PATH=/gpfs1/scratch/ryan/miniconda3/envs/lineage/lib:$LD_LIBRARY_PATH

conda activate lineage

cd /gpfs1/scratch/ryan

#for FILE in $(ls stats_op)
#do
#    OUTFILE=$(echo $FILE | sed 's/.csv//')_lineage.csv
#    lineage.py -i stats_op/$FILE -o stats_op_lineage/$OUTFILE
#done

lineage.py -m --filter kingdom fungi -i /gpfs1/scratch/elaine/International/Species_global.tsv -o out.csv > 1.txt