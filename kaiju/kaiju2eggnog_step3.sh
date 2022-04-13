#!/bin/bash
### Job Name
#PBS -N annot_to_eggnog

### Project code
#PBS -q std_prio
#PBS -j oe
#PBS -l select=1:ncpus=32
#PBS -J 1-70
#PBS -o logs

cd $PBS_O_WORKDIR

NAME=$(cat /gpfs1/scratch/rikky/projects/parkinson_microbiome/samples.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )
KAIJU="kaiju_output/"$NAME".out.txt"
PROT="proteins/"$NAME".prots.faa"
ORTH="output/"$NAME".emapper.seed_orthologs"
ANNOT="output/"$NAME".emapper.annotation"

# RAND=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 16 | head -n 1)

TMP="/tmp/emapper_"$NAME"/"

mkdir -p $TMP
cp ./apps/eggnog/eggnog-mapper/data/eggnog.db $TMP

time ./apps/eggnog/eggnog-mapper/emapper.py --annotate_hits_table $ORTH \
--data_dir $TMP \
--no_file_comments -o $ANNOT --cpu 32

rm $TMP"/eggnog.db"
rmdir $TMP
