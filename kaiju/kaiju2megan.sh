#!/bin/bash
### Job Name
#PBS -N kaiju2megan

### Project code
#PBS -q std_prio
#PBS -j oe
#PBS -l select=1:ncpus=32
#PBS -J 1-70
#PBS -o logs

cd $PBS_O_WORKDIR

module load megan_toolbox/0.1

NAME=$( cat /gpfs1/scratch/rikky/projects/parkinson_microbiome/samples.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )

echo "Converting kaiju to tsv format"
INPUT_KAIJU="output/"$NAME".out.txt"
OUTPUT_CSV="tsv/"$NAME".tsv"

kaiju_taxon2tsv -i $INPUT_KAIJU -f 25 -o $OUTPUT_CSV

echo "Converting abundance csv file to MEGAN"
OUTPUT_MEGAN="megan/"$NAME".megan"

csv2megan $OUTPUT_CSV $OUTPUT_MEGAN
