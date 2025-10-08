#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=LJA_assembly
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/LJA_assembly_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/LJA_assembly_error_%j.o

READS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads/Ms-0"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly/LJA"
LJA_IMG="/containers/apptainer/lja-0.2.sif"

# Create output directory
mkdir -p $OUT_DIR

# Assemble with LJA
apptainer run --bind /data $LJA_IMG \
lja -o $OUT_DIR --reads $READS_DIR/* \
-t $SLURM_CPUS_PER_TASK