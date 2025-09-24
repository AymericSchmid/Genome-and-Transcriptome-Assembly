#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=flye_assembly
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/flye_assembly_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/flye_assembly_error_%j.o

READS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads/Ms-0"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly/flye"
FLYE_IMG="/containers/apptainer/flye_2.9.5.sif"

mkdir -p $OUT_DIR

apptainer run --bind /data $FLYE_IMG \
flye --pacbio-hifi $READS_DIR/* -o $OUT_DIR \
-t $SLURM_CPUS_PER_TASK