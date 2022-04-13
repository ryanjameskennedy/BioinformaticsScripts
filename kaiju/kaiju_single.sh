#!/bin/bash
### Job Name
#PBS -N kaiju

### Project code
#PBS -q std
#PBS -j oe
#PBS -l select=1:ncpus=32
#PBS -o logs

cd $PBS_O_WORKDIR

module load kaiju

# =================== PARAMETERS =====================
NAME=""
FASTQ1=""
FASTQ2=""
# ===================================================

OUTPUT="output/"$NAME
TABLE="output/"$NAME

NODE=/gpfs1/db/kaiju/nr_euk_2019-07-23/nodes.dmp
DB=/gpfs1/db/kaiju/nr_euk_2019-07-23/kaiju_db_nr_euk.fmi
DMP=/gpfs1/db/kaiju/nr_euk_2019-07-23/names.dmp

mkdir -p output

time kaiju -t $NODE -f $DB -i $FASTQ1 -j $FASTQ2 -z 32 -e 5 -v -o $OUTPUT".out"

kaiju-addTaxonNames -t $NODE -n $DMP -i $OUTPUT".out" -o $OUTPUT".out.txt"

kaiju2table -t $NODE -n $DMP -r phylum -e -p -o $TABLE".phylum.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r class -e -p -o $TABLE".class.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r order -e -p -o $TABLE".order.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r family -e -p -o $TABLE".family.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r genus -e -p -o $TABLE".genus.txt"  $OUTPUT".out"
kaiju2table -t $NODE -n $DMP -r species -e -p -o $TABLE".species.txt"  $OUTPUT".out"

