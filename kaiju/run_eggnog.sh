#!/bin/bash
### Job Name
#PBS -N eggnog_SSC

### Project code
#PBS -q std_prio
#PBS -j oe
#PBS -l select=1:ncpus=32
#PBS -J 1-77
#PBS -o logs

cd $PBS_O_WORKDIR

module load kaiju

NAME=$(cat ../names.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )

KAIJU="kaiju_output/"$NAME".out.txt"
PROT="proteins/"$NAME".prots.faa"
ORTH="output/"$NAME".emapper.seed_orthologs"
ANNOT="output/"$NAME".emapper.annotation"

# Extract Protein Sequences
perl apps/extract_protein_seqs.pl $KAIJU > $PROT

# Run Eggnog Mapper
time ./apps/eggnog/eggnog-mapper/emapper.py -m diamond --no_annot --cpu 32 \
-i $PROT \
--data_dir ./apps/eggnog/eggnog-mapper/data \
--override \
--output_dir output \
--output $NAME


# Run annotation using tmp dir
TMP="/tmp/emapper_"$NAME"/"
mkdir -p $TMP
cp ./apps/eggnog/eggnog-mapper/data/eggnog.db $TMP

time ./apps/eggnog/eggnog-mapper/emapper.py \
--annotate_hits_table $ORTH \
--data_dir $TMP \
--no_file_comments -o $ANNOT --cpu 32

rm $TMP"/eggnog.db"
rmdir $TMP
