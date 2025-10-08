#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=busco_qual_assess
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/busco_qual_assess_output_%A_%a.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/busco_qual_assess_error_%A_%a.o
#SBATCH --array=0-3

ASSEMBLY_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly_QC/busco"
BUSCO_IMG="/containers/apptainer/busco_6.0.0.sif"

FLYE_FA="$ASSEMBLY_DIR/flye/assembly.fasta"
HIFIASM_FA="$ASSEMBLY_DIR/hifiasm/asm.bp.p_ctg.fa"
LJA_FA="$ASSEMBLY_DIR/LJA/assembly.fasta"
TRINITY_FA="$ASSEMBLY_DIR/trinity.Trinity.fasta"

FAS=($FLYE_FA $HIFIASM_FA $LJA_FA $TRINITY_FA)
MODES=('genome' 'genome' 'genome' 'transcriptome')
NAMES=('flye' 'hifiasm' 'LJA' 'trinity')

LINEAGE='brassicales_odb10'

# Create output directory
mkdir -p $OUT_DIR

cd $OUT_DIR

# Load BUSCO module
module load BUSCO

# Run BUSCO on each assembly (via array)
busco -i ${FAS[SLURM_ARRAY_TASK_ID]} \
-m ${MODES[SLURM_ARRAY_TASK_ID]} \
-o ${NAMES[SLURM_ARRAY_TASK_ID]} \
-l $LINEAGE \
-c $SLURM_CPUS_PER_TASK \
--download_path $OUT_DIR/busco_downloads_$SLURM_ARRAY_TASK_ID