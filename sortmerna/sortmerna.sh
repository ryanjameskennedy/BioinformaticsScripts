#!/bin/bash
### Job Name
#PBS -N sortmerna

### Project code
#PBS -q std
#PBS -j oe
#PBS -l select=1:ncpus=32
#PBS -o logs


module load sortmerna/4.2.0

cd $PBS_O_WORKDIR

# ====================================
NAME=""
FASTQ1=""
FASTQ2=""
# ====================================

WORKDIR="workdir"

mkdir -p rrna non_rrna workdir logs

time sortmerna --ref /gpfs1/db/sortmerna/4.0/silva-arc-16s-id95.fasta --ref /gpfs1/db/sortmerna/4.0/rfam-5.8s-database-id98.fasta --ref /gpfs1/db/sortmerna/4.0/rfam-5s-database-id98.fasta --ref /gpfs1/db/sortmerna/4.0/silva-arc-23s-id98.fasta --ref /gpfs1/db/sortmerna/4.0/silva-bac-16s-id90.fasta sta --ref /gpfs1/db/sortmerna/4.0/silva-bac-23s-id98.fasta --ref /gpfs1/db/sortmerna/4.0/silva-euk-18s-id95.fasta  --ref /gpfs1/db/sortmerna/4.0/silva-euk-28s-id98.fasta \
--reads $FASTQ1 --reads $FASTQ2 --aligned rrna/$NAME --other non_rrna/$NAME --fastx --paired_in --threads 32 --workdir $WORKDIR -blast 1 -num_alignments 1


