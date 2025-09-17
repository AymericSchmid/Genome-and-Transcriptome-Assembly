#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=03:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=reads_filtering
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/reads_filtering_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/reads_filtering_error_%j.o

FASTP_IMG="/containers/apptainer/fastp_0.24.1.sif"
READS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads_filt"

RNA_R1="$READS_DIR/RNAseq_Sha/ERR754081_1.fastq.gz"
RNA_R2="$READS_DIR/RNAseq_Sha/ERR754081_2.fastq.gz"
HIFI="$READS_DIR/Ms-0/ERR11437313.fastq.gz"

R1_BASE="$(basename "${RNA_R1}" .fastq.gz)"
R2_BASE="$(basename "${RNA_R2}" .fastq.gz)"
HIFI_BASE="$(basename "${HIFI}" .fastq.gz)"

mkdir -p $OUT_DIR

# Illumina RNA-seq
apptainer run --bind /data $FASTP_IMG fastp \
    -i $RNA_R1 -I $RNA_R2 \
    -o "$OUT_DIR/${R1_BASE}.trimmed.fastq.gz" -O "$OUT_DIR/${R2_BASE}.trimmed.fastq.gz" \
    --detect_adapter_for_pe \
    --cut_front --cut_tail --cut_window_size 4 --cut_mean_quality 20 \
    --length_required 30 \
    -h "${OUT_DIR}/fastp_rna.html"

# PacBio HiFi (no filtering)
apptainer run --bind /data $FASTP_IMG fastp \
    -i $HIFI \
    -o "$OUT_DIR/${HIFI_BASE}.copy.fastq.gz" \
    -A -Q -L \
    -h "${OUT_DIR}/fastp_hifi.html"