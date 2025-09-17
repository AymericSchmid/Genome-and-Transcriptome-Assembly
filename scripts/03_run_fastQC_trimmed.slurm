#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=03:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=run_fastQC_trimm
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/run_fastQC_trimm_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/run_fastQC_trimm_error_%j.o

FASTQC_IMG="/containers/apptainer/fastqc-0.12.1.sif"
FILT_READS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads_filt"
RESULTS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads_QC"

mkdir $RESULTS_DIR

# Only on RNAseq reads => HIFI are not cleaned
apptainer run --bind /data $FASTQC_IMG fastqc -t $SLURM_CPUS_PER_TASK -o $RESULTS_DIR $FILT_READS_DIR/*.trimmed.fastq.gz