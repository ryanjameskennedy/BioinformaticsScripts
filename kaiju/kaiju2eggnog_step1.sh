#!/bin/bash
### Job Name
#PBS -N extract_prot_seq

### Project code
#PBS -q std_prio
#PBS -j oe
#PBS -l select=1:ncpus=1
#PBS -J 1-70
#PBS -o logs

cd $PBS_O_WORKDIR

module load kaiju

NAME=$(cat /gpfs1/scratch/rikky/projects/parkinson_microbiome/samples.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )
KAIJU="kaiju_output/"$NAME".out.txt"
PROT="proteins/"$NAME".prots.faa"

perl apps/extract_protein_seqs.pl $KAIJU > $PROT
