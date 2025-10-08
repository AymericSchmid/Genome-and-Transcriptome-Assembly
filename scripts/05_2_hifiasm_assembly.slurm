#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=hifiasm_assembly
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/hifiasm_assembly_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/hifiasm_assembly_error_%j.o

READS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads/Ms-0"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly/hifiasm"
HIFIASM_IMG="/containers/apptainer/hifiasm_0.25.0.sif"

# Create output directory
mkdir -p $OUT_DIR

# Assemble with hifiasm
apptainer run --bind /data $HIFIASM_IMG \
hifiasm -o $OUT_DIR/asm -t $SLURM_CPUS_PER_TASK $READS_DIR/*

# Convert primary contigs from GFA to FASTA
awk -F'\t' '$1=="S"{print ">"$2"\n"$3}' "$OUT_DIR/asm.bp.p_ctg.gfa" > "$OUT_DIR/asm.bp.p_ctg.fa"