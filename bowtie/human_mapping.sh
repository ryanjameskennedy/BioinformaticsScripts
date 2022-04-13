#!/bin/bash
### Job Name
#PBS -N hg19_map

### Project code
#PBS -q std_prio
#PBS -j oe
#PBS -l select=1:ncpus=16
#PBS -J 1-123
#PBS -o logs

cd $PBS_O_WORKDIR

module load samtools
module load bowtie2

NAME=$(cat /gpfs1/scratch/rikky/projects/bammbe_microbiomes/analysis/names.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )
WD="/gpfs1/scratch/rikky/projects/bammbe_microbiomes"
FASTQ1=$WD"/analysis/0.data/"$NAME".R1.tr.fastq"
FASTQ2=$WD"/analysis/0.data/"$NAME".R2.tr.fastq"
REF="/gpfs1/scratch/rikky/db/GRCh38/bowtie2/GRCh38"
UNMAP="unmapped/"$NAME".fastq"

bowtie2 --un-conc $UNMAP --very-sensitive-local -p 16 -x $REF -1 $FASTQ1 -2 $FASTQ2 -S "output/"$NAME".sam"
samtools view -@ 20 -bS -f2 "output/"$NAME".sam" > "output/"$NAME".bam"
rm -f "output/"$NAME".sam"
