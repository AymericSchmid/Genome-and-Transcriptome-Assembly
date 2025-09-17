#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1M
#SBATCH --time=00:05:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=dir_set_up
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/dir_set_up_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/dir_set_up_error_%j.o

READS_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/Reads"

mkdir $READS_DIR

ACCESSION="Ms-0"
ln -s /data/courses/assembly-annotation-course/raw_data/$ACCESSION $READS_DIR
ln -s /data/courses/assembly-annotation-course/raw_data/RNAseq_Sha $READS_DIR