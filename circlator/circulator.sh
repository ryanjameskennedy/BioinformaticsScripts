#PBS -N circulator
#PBS -l select=1:ncpus=64
#PBS -q std
#PBS -j oe
#PBS -o logs
#PBS -l walltime=12:00:00
###PBS -J 1-25

# =======================================================
# LOAD PBS MODULES
# =======================================================
cd $PBS_O_WORKDIR

source /gpfs1/scratch/shruti/anaconda3/etc/profile.d/conda.sh

##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Unicycler/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Unicyler/bin:$PATH


##conda activate Busco5
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Busco5/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Busco5/bin:$PATH



##R1=$(cat R1.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )
##R2=$(cat R2.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )
##outdir=$(cat out.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )


##Assembly of Illumina Only:
##unicycler -1 $R1 -2 $R2 -o $outdir -t 64 


##Busco
assembly=$(cat fasta.path | head -n $PBS_ARRAY_INDEX | tail -n 1 )
busco_out=$(cat busco_out.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )
dir_path=$(cat dir.path | head -n $PBS_ARRAY_INDEX | tail -n 1 )

##busco -i ${assembly} -o $busco_out -l /gpfs1/db/busco/odb10/bacteria_odb10/ -m genome -c 64 -f

##rRNA Identification
##conda activate Barnap
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Barnap/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Barnap/bin:$PATH

##barrnap --threads 32 --kingdom bac --outseq ${assembly}.16S.faa < ARISO705/ARISO705.fasta > ${assembly}.16S.gff 

##Cluster rRNA
##module load usearch/8.1
##usearch -cluster_fast ${assembly}.16S.faa -id 0.99 -centroids ${assembly}.16S.usearch.fasta

##Blast Vs Silva SSU

##module load ncbi-blast/2.11.0+ 
##blastn -db /gpfs1/scratch/shruti/SILVA/SILVA_138.1_LSURef_NR99_tax_silva.fasta -query ${assembly}.16S.usearch.fasta -max_hsps 5 -outfmt 6 -max_target_seqs 5 -out ${assembly}.SILVA.tsv -num_threads 10
##sort -n -k3 ARISO599.fasta.SILVA.tsv

##taxseedo

##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/taxseedo/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/taxseedo/bin:$PATH

##conda activate taxseedo

##identify_query.py -fa -sp -b -p -i ARISO705/ARISO705.fasta -o ARISO705/taxseedo_out


##FastANI

export PATH=/gpfs1/scratch/shruti/anaconda3/envs/FastANI/bin:$PATH
conda activate FastANI

##mkdir ARISO705/ANI

fastANI -q ARISO705/ARISO705.fasta --rl segmentaa -t 16 -o ARISO705/ANI/ARISO705.ANI.aa 
fastANI -q ARISO705/ARISO705.fasta --rl segmentab -t 16 -o ARISO705/ANI/ARISO705.ANI.ab
fastANI -q ARISO705/ARISO705.fasta --rl segmentac -t 16 -o ARISO705/ANI/ARISO705.ANI.ac
fastANI -q ARISO705/ARISO705.fasta --rl segmentad -t 16 -o ARISO705/ANI/ARISO705.ANI.ad
fastANI -q ARISO705/ARISO705.fasta --rl segmentae -t 16 -o ARISO705/ANI/ARISO705.ANI.ae
fastANI -q ARISO705/ARISO705.fasta --rl segmentaf -t 16 -o ARISO705/ANI/ARISO705.ANI.af
fastANI -q ARISO705/ARISO705.fasta --rl segmentag -t 16 -o ARISO705/ANI/ARISO705.ANI.ag
fastANI -q ARISO705/ARISO705.fasta --rl segmentah -t 16 -o ARISO705/ANI/ARISO705.ANI.ah
fastANI -q ARISO705/ARISO705.fasta --rl segmentai -t 16 -o ARISO705/ANI/ARISO705.ANI.ai
fastANI -q ARISO705/ARISO705.fasta --rl segmentaj -t 16 -o ARISO705/ANI/ARISO705.ANI.aj
fastANI -q ARISO705/ARISO705.fasta --rl segmentak -t 16 -o ARISO705/ANI/ARISO705.ANI.ak
fastANI -q ARISO705/ARISO705.fasta --rl segmental -t 16 -o ARISO705/ANI/ARISO705.ANI.al

##Prodigal

##source /gpfs1/scratch/shruti/anaconda3/etc/profile.d/conda.sh
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Prokka/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Prokka/bin:$PATH

##prokka_dir=$(cat prokka_out.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 ) 

##prokka --force --prefix .annot --outdir $prokka_dir --addgenes --addmrna --cpus 64 --rfam  ${sample}.fasta

##Microbeannotator
