#PBS -N nano_annot
#PBS -l select=1:ncpus=64
#PBS -q std
#PBS -j oe
#PBS -o logs
#PBS -l walltime=12:00:00
###PBS -J 1-92

# =======================================================
# LOAD PBS MODULES
# =======================================================
cd $PBS_O_WORKDIR


##assembly=$(cat nanopore.fasta | head -n $PBS_ARRAY_INDEX | tail -n 1 )
##reads=$(cat nanopore.correctReads | head -n $PBS_ARRAY_INDEX | tail -n 1 )
##DIR=$(echo $circ | cut -d '/' -f2 | cut -d '_' -f1)

source /gpfs1/scratch/shruti/anaconda3/etc/profile.d/conda.sh
export PATH=/gpfs1/scratch/shruti/anaconda3/envs/CheckM/bin:$PATH
checkm data setRoot /gpfs1/scratch/shruti/anaconda3/envs/CheckM/checkm_data/

checkm lineage_wf 1.Assemblies CheckM_lineage_wf -t 64