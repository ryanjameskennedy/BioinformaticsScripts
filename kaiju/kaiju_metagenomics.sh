#!/bin/bash
### Job Name
#PBS -N kaiju

### Project code
#PBS -q std_prio
#PBS -j oe
#PBS -l select=1:ncpus=32
#PBS -J 1-70
#PBS -o logs

cd $PBS_O_WORKDIR

module load kaiju

NAME=$(cat /gpfs1/scratch/rikky/projects/parkinson_microbiome/samples.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )
FASTQ1="unmapped/"$NAME".1.fastq"
FASTQ2="unmapped/"$NAME".2.fastq"
OUTPUT="output/"$NAME
TABLE="tables/"$NAME

NODE=/gpfs1/db/kaiju/nr_euk_2019-07-23/nodes.dmp
DB=/gpfs1/db/kaiju/nr_euk_2019-07-23/kaiju_db_nr_euk.fmi
DMP=/gpfs1/db/kaiju/nr_euk_2019-07-23/names.dmp

time kaiju -t $NODE -f $DB -i $FASTQ1 -j $FASTQ2 -z 32 -e 5 -v -o $OUTPUT".out"

kaiju-addTaxonNames -t $NODE -n $DMP -i $OUTPUT".out" -o $OUTPUT".out.txt"

kaiju2table -t $NODE -n $DMP -r phylum -e -p -o $TABLE".phylum.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r class -e -p -o $TABLE".class.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r order -e -p -o $TABLE".order.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r family -e -p -o $TABLE".family.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r genus -e -p -o $TABLE".genus.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r species -e -p -o $TABLE".species.txt"  $OUTPUT".out"

