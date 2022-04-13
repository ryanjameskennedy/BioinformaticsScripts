#!/bin/bash
### Job Name
#PBS -N map_to_eggnog

### Project code
#PBS -q std_prio
#PBS -j oe
#PBS -l select=1:ncpus=64
#PBS -J 1-70
#PBS -o logs

cd $PBS_O_WORKDIR

module load kaiju

NAME=$(cat /gpfs1/scratch/rikky/projects/parkinson_microbiome/samples.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )
KAIJU="kaiju_output/"$NAME".out.txt"
PROT="proteins/"$NAME".prots.faa"

time apps/eggnog/eggnog-mapper/emapper.py -m diamond --no_annot --cpu 64 \
-i $PROT \
--data_dir apps/eggnog/eggnog-mapper/data \
--override \
--output_dir output \
--output $NAME
