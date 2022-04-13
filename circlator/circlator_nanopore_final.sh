#PBS -N nano_annot
#PBS -l select=1:ncpus=64
#PBS -q std
#PBS -j oe
#PBS -o logs
###PBS -l walltime=12:00:00
#PBS -J 1-4

# =======================================================
# LOAD PBS MODULES
# =======================================================
cd $PBS_O_WORKDIR


##assembly=$(cat nanopore.fasta | head -n $PBS_ARRAY_INDEX | tail -n 1 )
reads=$(cat nanopore.correctReads | head -n $PBS_ARRAY_INDEX | tail -n 1 )
DIR=$(echo $assembly | cut -d '/' -f2 | cut -d '_' -f1)
##cir=${echo $assembly | cut -d '/' -f2 }

##mkdir $DIR

source /gpfs1/scratch/shruti/anaconda3/etc/profile.d/conda.sh
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Circlator/bin:$PATH
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Circlator/bin:$PATH

conda activate Circlator
module load canu/2.0
module load bwa/0.7.17 
module load samtools/1.9

circlator all --threads 64 --verbose --data_type nanopore-corrected ${assembly}.fasta $reads ${DIR}/Circlator
##circlator all --threads 32 --verbose --data_type nanopore-corrected nanopore_isolates/ARISO736_pilon_canu.fasta  nanopore_isolates/ARISO736.correctedReads.fasta.gz ARISO736/Circlator
##circlator all --threads 32 --verbose --data_type nanopore-corrected nanopore_isolates/ARISO286_pilon_canu.fasta  nanopore_isolates/ARISO286.correctedReads.fasta.gz ARISO286/Circlator

##cp ${DIR}/Circlator/06.fixstart.fasta ${DIR}/$cir"_circ.fasta"

##ls ${DIR}/*_circ.fasta > circ_out

##circ=$DIR"/"$DIR".fasta"

##conda activate Busco5
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Busco5/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Busco5/bin:$PATH

##busco -i ${circ} -o ${DIR}_BUSCO -l /gpfs1/db/busco/odb10/bacteria_odb10/ -m genome -c 64 -f

##checkm

##source /gpfs1/scratch/shruti/anaconda3/etc/profile.d/conda.sh
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/CheckM/bin:$PATH
##checkm data setRoot /gpfs1/scratch/shruti/anaconda3/envs/CheckM/checkm_data/

##checkm lineage_wf $DIR ${DIR}_checkm_out -t 64 -x fasta


##rRNA Identification

##conda activate Barnap
#3export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Barnap/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Barnap/bin:$PATH

##barrnap --threads 32 --kingdom bac --outseq ${circ}.16S.fasta < ${circ} > ${circ}.16S.gff 

##Cluster rRNA
##module load usearch/8.1
##usearch -cluster_fast ${circ}.16S.fasta -id 0.99 -centroids ${circ}.16S.usearch.fasta

##Blast Vs Silva SSU

##module load ncbi-blast/2.11.0+ 
##blastn -db /gpfs1/scratch/shruti/SILVA/SILVA_138.1_LSURef_NR99_tax_silva.fasta -query ${circ}.16S.usearch.fasta -max_hsps 1 -outfmt 6 -max_target_seqs 5 -out ${circ}.SILVA.tsv -num_threads 10


##taxseedo
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/taxseedo/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/taxseedo/bin:$PATH
##conda activate taxseedo

##identify_query.py -fa -sp -b -p -i $circ -o ${dir_path}/taxseedo_out


##FastANI

##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/FastANI/bin:$PATH
##conda activate FastANI

##circ=$(cat nanopore.fasta | head -n $PBS_ARRAY_INDEX | tail -n 1 )

##mkdir ${DIR}/ANI

##fastANI -q $circ --rl segmentaa -t 16 -o ${dir_path}/ANI/$dir_path.ANI.aa 
##fastANI -q $circ --rl segmentab -t 16 -o ${dir_path}/ANI/$dir_path.ANI.ab
##fastANI -q $circ --rl segmentac -t 16 -o ${dir_path}/ANI/$dir_path.ANI.ac
##fastANI -q $circ --rl segmentad -t 16 -o ${dir_path}/ANI/$dir_path.ANIad
##fastANI -q $circ --rl segmentae -t 16 -o ${dir_path}/ANI/$dir_path.ANIae
##fastANI -q $circ --rl segmentaf -t 16 -o ${dir_path}/ANI/$dir_path.ANIaf
##fastANI -q $circ --rl segmentag -t 16 -o ${dir_path}/ANI/$dir_path.ANIag
##fastANI -q $circ --rl segmentah -t 16 -o ${dir_path}/ANI/$dir_path.ANIah
##fastANI -q $circ --rl segmentai -t 16 -o ${dir_path}/ANI/$dir_path.ANIai
##fastANI -q $circ --rl segmentaj -t 16 -o ${dir_path}/ANI/$dir_path.ANIaj
##fastANI -q $circ --rl segmentak -t 16 -o ${dir_path}/ANI/$dir_path.ANIak
##fastANI -q $circ --rl segmental -t 16 -o ${dir_path}/ANI/$dir_path.ANI.al

##Prodigal

##source /gpfs1/scratch/shruti/anaconda3/etc/profile.d/conda.sh
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Prokka/bin:$PATH
##export PATH=/gpfs1/scratch/shruti/anaconda3/envs/Prokka/bin:$PATH

##prokka_dir=$(cat prokka_out.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 ) 

##prokka --force --prefix .annot --outdir ${DIR}/Prokka_out --addgenes --addmrna --cpus 64 --rfam  ${circ}.fasta
