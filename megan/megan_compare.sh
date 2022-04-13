#!/bin/bash
### Job Name
#PBS -N megan_comp

### Project code
#PBS -q std_prio
#PBS -j oe
#PBS -l select=1:ncpus=32
#PBS -o logs

cd $PBS_O_WORKDIR

module load megan_toolbox/0.1

megan_compare -m absolute -i megan.txt -o parkinson.abs.megan
megan_compare -m relative -i megan.txt -o parkinson.rel.megan
