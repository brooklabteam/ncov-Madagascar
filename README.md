# ncov-Madagascar

Here, we outline scripts for analysis of Madagascar SARS-CoV-2 sequences. We first undertook a broadbrush analysis using a local Nexstrain build, then built on that to construct more sophisticated subsequent analyses in BEAST. To get a local version of Nextstrain's SARS-CoV-2 workflow up and running on your home computer, please see their extremely detailed documentation [here](https://docs.nextstrain.org/projects/ncov/en/latest/index.html).

## Nextstrain Local Analysis for Madagascar

1. After installing a local version of nextstrain, clone the nextstrain SARS-CoV-2 github to your local computer via:

```
git clone https://github.com/nextstrain/ncov.git
```
See [here](https://docs.nextstrain.org/projects/ncov/en/latest/analysis/setup.html) for details on installation and setup.

2. In terminal, cd into the "ncov" directory. Activate your local nextstrain environment with:
```
conda activate nexstrain
```

3. For this analysis, we constructed our own SARS-CoV-2 metadata. These curated metadata files are already included in this repository, so *feel free to skip to step #4 to proceed* unless you want to practice the manual download. We do not include the upstream raw metadata files here due to their large size. If, however, you would like to try, please follow the instructions below:

- Download all SARS-CoV-2 sequences and metadata from GISAID. Go to "EpiCoV:Downloads", then pick "FASTA" and "metadata". Unzip the metadata and place the metadata .tsv ("allGISAID_metadata_2022_04_01.tsv") and the fasta zip file ("allGISAID_sequences_fasta_2022_04_01.tar.xz") in a new "sequence-prep" subfolder of your ncov clone. We have included this "nextstrain-scripts/sequence-prep" subfolder in this GitHub repo for ease of access to the data -- however, it does not include the initial dataset due to overlarge file size.

- Now, subselect the sequences you need for analysis, here selecting all sequences from Madagascar, plus a random sampling of sequences from  Africa, Europe, and the Globe. You can do this by kicking off the "select-seq.txt" script in the main ncov directory using:

```
sh -e select-seq.txt
```

- This file is stored here in the "nextstrain-scripts" subfolder for your convenience. The script included here subselects for 792 Madagascar sequences, which were collected from the beginning of the pandemic through July 18, 2021, and then randomly subselects samples from the other regions within that same period. If re-running this analysis on a later sample subset, edit the "select-seq.txt" file to reflect these new dates. Note that, because the genome files are massive, this script will take a long time to run on your local computer (~6-7 hours on mine). 
- Note that the original GISAID downloads and most of the interim metadata .tsv and sequence .fasta files are too large for uploading to GitHub. **However, the final results of this curation ("subsampled_metadata_gisaid_edit.tsv" and "subsampled_sequences_gisaid.fasta") ready for input into the nextstrain build are included in the "nexstrain-scripts/sequence-prep" subfolder**.
- Once the sequences have been selected for analysis, it is time to clean the metadata a little to improve the location identification for the Madagascar sequences, based on our more advanced understanding of the Madagascar landscape in which they were collected. For this step, run the Rscript "doc-seq.R" within the "nextstrain-scripts/sequence-prep" subfolder to produce an edited metadata file. (This script references another dataset "full_meta_madagascar.tsv" which is included here).

4. Copy your subselected sequence file ("nextstrain-scripts/sequence-prep/subsampled_sequences_gisaid.fasta") and edited metadata file ("nextstrain-scripts/sequence-prep/subsampled_metadata_gisaid_edit.tsv") to the "data" subfolder of your local "ncov" repo and set up your nexstrain build.

5. Copy the two files from the "default-edits" subfolder of the nextstrain-scripts folder into the "defaults" folder in the ncov repo. These will be "color_ordering.tsv" and "lat_longs.tsv".

6. We include the the source files for the Madagascar Nextstrain build in this repo under "nextstrain-scripts/builds/Madagascar" for ease of viewing here. To run the build, copy the "Madagascar" folder stored here in the "nexstrain-scripts/builds" subfolder into the "my_profiles" subfolder of your local 'ncov' repo. Visit the Nextstrain website [here](https://docs.nextstrain.org/projects/ncov/en/latest/guides/workflow-config-file.html) for details on how to edit the specifications of this build.

7. Then, within the your local ncov main repository, kick off your build with the following command line command:
```
snakemake --profile my_profiles/Madagascar -p
```

8. Once complete (it will take a few hours to build), it will produce an "auspice" folder within ncov, which we include here (slightly edited ad-hoc to make clade_membership the default coloring scheme). This folder powers the genome visualization linked below.

9. Visualize the output in auspice at: [https://nextstrain.org/community/brooklabteam/ncov-Madagascar](https://nextstrain.org/community/brooklabteam/ncov-Madagascar)

10. Once you've completed the Nextstrain build, go to the [ncov-Madagascar-analysis](https://github.com/brooklabteam/ncov-Madagascar-analysis) repo for additional analyses.


