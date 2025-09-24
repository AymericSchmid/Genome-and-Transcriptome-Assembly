#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=trinity_assembly
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/trinity_assembly_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/trinity_assembly_error_%j.o

READS_1="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads_filt/ERR754081_1.trimmed.fastq.gz"
READS_2="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads_filt/ERR754081_2.trimmed.fastq.gz"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly/trinity"
mkdir -p $OUT_DIR

module add Trinity

Trinity \
--seqType fq \
--left $READS_1 \
--right $READS_2 \
--CPU $SLURM_CPUS_PER_TASK \
--max_memory 60G \
--output $OUT_DIR \
--min_contig_length 200 \
--no_normalize_reads # normalization can reduce sensitivity on low-abundance reads