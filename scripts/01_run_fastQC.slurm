#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=03:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=run_fastQC
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/run_fastQC_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/run_fastQC_error_%j.o

FASTQC_IMG="/containers/apptainer/fastqc-0.12.1.sif"
READS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads"
RESULTS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads_QC"
ACCESSION="Ms-0"

# Create QC output directory
mkdir -p $RESULTS_DIR

# Run FastQC on genomic and RNA-seq reads
apptainer run --bind /data $FASTQC_IMG fastqc -t $SLURM_CPUS_PER_TASK -o $RESULTS_DIR $READS_DIR/$ACCESSION/* $READS_DIR/RNAseq_Sha/*