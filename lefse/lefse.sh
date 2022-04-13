perl add_cohort.pl > merged_abund.species.txt

module load lefse
singularity exec $LEFSE_IMAGE format_input.py merged_abund.species.txt merged_abund.species.lefse.txt -u 1 -c 2 -o -1
singularity exec $LEFSE_IMAGE run_lefse.py merged_abund.species.lefse.txt merged_abund.species.lefse.result.txt
perl filter_lefse_output.pl merged_abund.species.lefse.result.txt > merged_abund.species.lefse.result.filtered.txt

singularity exec $LEFSE_IMAGE plot_res.py --dpi 300 --max_feature_len 120 merged_abund.species.lefse.result.txt lefse_species_biomarkers.png
singularity exec $LEFSE_IMAGE plot_cladogram.py --dpi 300 --format png merged_abund.species.lefse.result.txt lefse_species_biomarkers_cladogram.png
singularity exec $LEFSE_IMAGE plot_features.py -f diff --archive zip merged_abund.species.lefse.txt merged_abund.species.lefse.result.txt species_biomarker_features.zip
