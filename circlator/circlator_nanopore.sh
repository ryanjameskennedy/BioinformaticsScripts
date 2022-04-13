#PBS -N AR291
#PBS -l select=1:ncpus=64
#PBS -q std
#PBS -j oe
#PBS -o logs
#PBS -l walltime=12:00:00
###PBS -J 1-33

# =======================================================
# LOAD PBS MODULES
# =======================================================
cd $PBS_O_WORKDIR


##input=$(cat 16S.input | head -n $PBS_ARRAY_INDEX | tail -n 1 )
##output=$(cat 16S.output | head -n $PBS_ARRAY_INDEX | tail -n 1 )

source /gpfs1/scratch/shruti/anaconda3/etc/profile.d/conda.sh

export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Circlator/bin:$PATH
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Circlator/bin:$PATH

conda activate Circlator

conda activate Circlator
module load canu/2.0
module load bwa/0.7.17 
module load samtools/1.9

circlator all --threads 64 --verbose --data_type nanopore-corrected nanopore_isolates/ARISO291_pilon_canu.fasta nanopore_isolates/ARISO291.correctedReads.fasta.gz ARISO291/Circlator

conda activate Busco5
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Busco5/bin:$PATH
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Busco5/bin:$PATH

busco -i ARISO291/ARISO291.fasta -o ARISO291_BUSCO -l /gpfs1/db/busco/odb10/bacteria_odb10/ -m genome -c 64 -f

##checkm

source /gpfs1/scratch/shruti/anaconda3/etc/profile.d/conda.sh
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/CheckM/bin:$PATH
checkm data setRoot /gpfs1/scratch/shruti/anaconda3/envs/CheckM/checkm_data/

checkm lineage_wf ARISO291/ ARISO291_checkm_out -t 64 -x fasta


##rRNA Identification

conda activate Barnap
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Barnap/bin:$PATH
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Barnap/bin:$PATH

barrnap --threads 32 --kingdom bac --outseq ARISO291/ARISO291.16S.fasta < ARISO291/ARISO291.fasta > ARISO291/ARISO291.16S.gff 

##Cluster rRNA
module load usearch/8.1
usearch -cluster_fast ARISO291/ARISO291.16S.fasta -id 0.99 -centroids ARISO291/ARISO291.16S.usearch.fasta

##Blast Vs Silva SSU

##module load ncbi-blast/2.11.0+ 
blastn -db /gpfs1/scratch/shruti/SILVA/SILVA_138.1_LSURef_NR99_tax_silva.fasta -query ARISO291/ARISO291.16S.usearch.fasta -max_hsps 1 -outfmt 6 -max_target_seqs 5 -out ARISO291/ARISO291.SILVA.tsv -num_threads 10


##taxseedo
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/taxseedo/bin:$PATH
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/taxseedo/bin:$PATH
conda activate taxseedo

identify_query.py -fa -sp -b -p -i ARISO291/ARISO291.fasta -o ARISO291/taxseedo_out


##FastANI

export PATH=/gpfs1/scratch/shruti/anaconda3/envs/FastANI/bin:$PATH
conda activate FastANI

##mkdir ${DIR}/ANI

fastANI -q ARISO291/ARISO291.fasta --rl segmentaa -t 16 -o ARISO291/ANI/ARISO291.ANI.aa 
fastANI -q ARISO291/ARISO291.fasta --rl segmentab -t 16 -o ARISO291/ANI/ARISO291.ANI.ab
fastANI -q ARISO291/ARISO291.fasta --rl segmentac -t 16 -o ARISO291/ANI/ARISO291.ANI.ac
fastANI -q ARISO291/ARISO291.fasta --rl segmentad -t 16 -o ARISO291/ANI/ARISO291.ANI.ad
fastANI -q ARISO291/ARISO291.fasta --rl segmentae -t 16 -o ARISO291/ANI/ARISO291.ANI.ae
fastANI -q ARISO291/ARISO291.fasta --rl segmentaf -t 16 -o ARISO291/ANI/ARISO291.ANI.af
fastANI -q ARISO291/ARISO291.fasta --rl segmentag -t 16 -o ARISO291/ANI/ARISO291.ANI.ag
fastANI -q ARISO291/ARISO291.fasta --rl segmentah -t 16 -o ARISO291/ANI/ARISO291.ANI.ah
fastANI -q ARISO291/ARISO291.fasta --rl segmentai -t 16 -o ARISO291/ANI/ARISO291.ANI.ai
fastANI -q ARISO291/ARISO291.fasta --rl segmentaj -t 16 -o ARISO291/ANI/ARISO291.ANI.aj
fastANI -q ARISO291/ARISO291.fasta --rl segmentak -t 16 -o ARISO291/ANI/ARISO291.ANI.ak
fastANI -q ARISO291/ARISO291.fasta --rl segmental -t 16 -o ARISO291/ANI/ARISO291.ANI.al

##FastANI

##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/FastANI/bin:$PATH
##conda activate FastANI

##mkdir ARISO880/ANI

##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentaa -t 16 -o ARISO880/ANI/ARISO880.ANI.aa 
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentab -t 16 -o ARISO880/ANI/ARISO880.ANI.ab
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentac -t 16 -o ARISO880/ANI/ARISO880.ANI.ac
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentad -t 16 -o ARISO880/ANI/ARISO880.ANI.ad
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentae -t 16 -o ARISO880/ANI/ARISO880.ANI.ae
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentaf -t 16 -o ARISO880/ANI/ARISO880.ANI.af
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentag -t 16 -o ARISO880/ANI/ARISO880.ANI.ag
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentah -t 16 -o ARISO880/ANI/ARISO880.ANI.ah
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentai -t 16 -o ARISO880/ANI/ARISO880.ANI.ai
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentaj -t 16 -o ARISO880/ANI/ARISO880.ANI.aj
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmentak -t 16 -o ARISO880/ANI/ARISO880.ANI.ak
##fastANI -q ARISO880/ARISO880_pilon_canu.fasta --rl segmental -t 16 -o ARISO880/ANI/ARISO880.ANI.al

##rRNA Identification


#3conda activate Barnap
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Barnap/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Barnap/bin:$PATH

#3barrnap --threads 32 --kingdom bac --outseq ARISO880/ARISO880.16S.fasta < ARISO880/ARISO880_pilon_canu.fasta > ARISO880/ARISO880.16S.gff 

##Cluster rRNA
##module load usearch/8.1
##usearch -cluster_fast ARISO880/ARISO880.16S.fasta -id 0.99 -centroids ARISO880/ARISO880.16S.usearch.fasta


##module load ncbi-blast/2.11.0+ 

##blastn -db /gpfs1/scratch/shruti/SILVA/SILVA_138.1_LSURef_NR99_tax_silva -query ARISO880/ARISO880.16S.usearch.fasta -max_hsps 5 -outfmt 6 -max_target_seqs 5 -out ARISO880/ARISO880.SILVA.blast.out -num_threads 64
