#!/bin/bash
### Job Name
#PBS -N bbduk

### Project code
#PBS -q intel
#PBS -j oe
#PBS -l select=1:ncpus=64
#PBS -o logs
#PBS -J 1-16

cd $PBS_O_WORKDIR

module load BBMap

NAME=$(cat names.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )
FASTQ1=$(cat read1.txt| head -n $PBS_ARRAY_INDEX | tail -n 1 )
FASTQ2=$(cat read2.txt| head -n $PBS_ARRAY_INDEX | tail -n 1 )

OUT1="trimmed/"$NAME".R1.tr.fastq"
OUT2="trimmed/"$NAME".R2.tr.fastq"
STAT="stats/"$NAME".stats"
REFSTAT="stats/"$NAME".refstats"


time bbduk.sh \
in=$FASTQ1 in2=$FASTQ2 out1=$OUT1 out2=$OUT2 ref=/cm/shared/apps/bio/BBMap/38.75/resources/adapters.fa ktrim=r \
k=21 mink=8 hdist=2 trimq=20 qtrim=r minlength=20 threads=64 stats=$STAT refstats=$REFSTAT tpe tbo

