#!/bin/bash
### Job Name
#PBS -N lefse_func

### Project code
#PBS -q intel
#PBS -j oe
#PBS -J 1-3

#PBS -l select=1:ncpus=32
#PBS -o logs

cd $PBS_O_WORKDIR


NAME=$(cat list_func.txt | head -n $PBS_ARRAY_INDEX | tail -n 1 )

FILE="inputs/"$NAME".kegg.norm.txt"
PREFIX="output/functions/"$NAME

module load lefse
singularity exec $LEFSE_IMAGE format_input.py $FILE $PREFIX".lefse.txt" -u 1 -c 2 -o -1
singularity exec $LEFSE_IMAGE run_lefse.py $PREFIX".lefse.txt" $PREFIX".lefse.result.txt"
perl filter_lefse_output.pl $PREFIX".lefse.result.txt" > $PREFIX".lefse.result.filt.txt"

singularity exec $LEFSE_IMAGE plot_res.py --dpi 300 --max_feature_len 120 $PREFIX".lefse.result.txt" $PREFIX"_biomarkers.png"
singularity exec $LEFSE_IMAGE plot_cladogram.py --dpi 300 --format png $PREFIX".lefse.result.txt" $PREFIX"_cladogram.png"
singularity exec $LEFSE_IMAGE plot_features.py -f diff --archive zip $PREFIX".lefse.txt" $PREFIX".lefse.result.txt" $PREFIX"_biomarker_feats.zip"

