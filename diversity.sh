#!/bin/bash
#SBATCH -J coremetrics
#SBATCH -p general
#SBATCH -N 4            # number of nodes
#SBATCH -c 32            # number of cores
#SBATCH --mem=128G
#SBATCH -t 2-03:00:00   # time in d-hh:mm:ss
#SBATCH -q public       # QOS
#SBATCH -o slurm.%j.out # file to save job's STDOUT (%j = JobId)
#SBATCH -e slurm.%j.err # file to save job's STDERR (%j = JobId)
#SBATCH --mail-user="apate231@asu.edu"
#SBATCH --mail-type=ALL # Send an e-mail when a job starts, stops, or fails
#SBATCH --export=NONE   # Purge the job-submitting shell environment

# Load required modules for job's environment
module load mamba/latest
source activate qiime2-2024.2
# module load openjdk-17.0.3_7-gcc-12.1.0
module list


cd /data/tsuzuki7/wild_rodent/data/rodent_output/dada2

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table dada2-ccs_table_filtered.qza \
  --m-metadata-file metadata.tsv \
  --p-sampling-depth 3771 \
  --o-rarefied-table rarefied-table.qza \
  --o-faith-pd-vector faith-pd.qza \
  --o-evenness-vector evenness.qza \
  --o-observed-features-vector observed-features.qza \
  --o-shannon-vector shannon.qza \
  --o-unweighted-unifrac-distance-matrix unweighted-unifrac.qza \
  --o-weighted-unifrac-distance-matrix weighted-unifrac.qza \
  --o-jaccard-distance-matrix jaccard.qza \
  --o-bray-curtis-distance-matrix bray-curtis.qza \
  --o-unweighted-unifrac-pcoa-results unweighted-unifrac-pcoa.qza \
  --o-weighted-unifrac-pcoa-results weighted-unifrac-pcoa.qza \
  --o-jaccard-pcoa-results jaccard-pcoa.qza \
  --o-bray-curtis-pcoa-results bray-curtis-pcoa.qza \
  --o-unweighted-unifrac-emperor unweighted-unifrac-emperor.qzv \
  --o-weighted-unifrac-emperor weighted-unifrac-emperor.qzv \
  --o-jaccard-emperor jaccard-emperor.qzv \
  --o-bray-curtis-emperor bray-curtis-emperor.qzv


qiime diversity alpha-group-significance \
  --i-alpha-diversity faith-pd.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization alpha-diversity.qzv

qiime diversity beta-group-significance \
  --i-distance-matrix weighted-unifrac.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column scientificName \
  --o-visualization beta-diversity.qzv


