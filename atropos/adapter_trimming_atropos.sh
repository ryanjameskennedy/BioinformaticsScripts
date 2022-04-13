#!/bin/bash
### Job Name
#PBS -N adapt_trim

### Project code
#PBS -q std_prio
#PBS -j oe
#PBS -l select=1:ncpus=8
#PBS -J 1-123
#PBS -o logs

cd $PBS_O_WORKDIR

module load atropos

FASTQ1=$(cat read1.txt| head -n $PBS_ARRAY_INDEX | tail -n 1 )
FASTQ2=$(cat read2.txt| head -n $PBS_ARRAY_INDEX | tail -n 1 )
NAME=$(cat names.txt| head -n $PBS_ARRAY_INDEX | tail -n 1 )
PREFIX="trimmed/"$NAME


atropos trim --threads 8 \
--input1 $FASTQ1 \
--input2 $FASTQ2 \
-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCACNNNNNNNNAATCTCGTATGCCGTCTTCTGCTTG \
-A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTCGGTCGCCGTATCATT \
-q 30,30 --trim-n --match-read-wildcards --minimum-length 30 \
-o $PREFIX".R1.tr.fastq" \
-p $PREFIX".R2.tr.fastq"
