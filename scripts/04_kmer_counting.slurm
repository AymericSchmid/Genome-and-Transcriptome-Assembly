#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=03:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=kmer_counting
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/kmer_counting_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/kmer_counting_error_%j.o

READS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads/Ms-0"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/kmer_counting"
JELLYFISH_IMG="/containers/apptainer/jellyfish:2.2.6--0"

mkdir -p $OUT_DIR

apptainer run --bind /data $JELLYFISH_IMG \
jellyfish count \
-C -m 21 -s 1600000000 -t $SLURM_CPUS_PER_TASK -o $OUT_DIR/reads.jf \
<(zcat $READS_DIR/*)

apptainer run --bind /data $JELLYFISH_IMG \
jellyfish histo \
-t $SLURM_CPUS_PER_TASK $OUT_DIR/reads.jf > $OUT_DIR/reads.histo