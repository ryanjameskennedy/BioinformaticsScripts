#PBS -N prokka
#PBS -l select=1:ncpus=64
#PBS -q std
#PBS -j oe
#PBS -o prokka
#PBS -l walltime=12:00:00

source /gpfs1/scratch/ryan/miniconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/ryan/miniconda3/envs/microbeannotator/bin:$PATH
export LD_LIBRARY_PATH=/gpfs1/scratch/ryan/miniconda3/envs/microbeannotator/lib:$LD_LIBRARY_PATH

conda activate microbeannotator
module load prodigal
#module load prokka

cd /gpfs1/scratch/justine/bacterial_isolates/ARISO187
mkdir -p 03_annotation/orf
prodigal -i 01_data/ARISO187.fasta -f gff -o 03_annotation/orf/ARISO187.gff -d 03_annotation/orf/ARISO187.cds
microbeannotator -i 03_annotation/orf/ARISO187.cds -d /gpfs1/scratch/ryan/MicrobeAnnotator_DB -o 03_annotation -m diamond -p 1 -t 32
#prokka --force --prefix ARISO187 --outdir 03_annotation --cpus 64 --rfam 01_data/ARISO187.fasta
