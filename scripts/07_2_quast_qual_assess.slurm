#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=quast_qual_assess
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/quast_qual_assess_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/quast_qual_assess_error_%j.o

ASSEMBLY_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly_QC/quast"
QUAST_IMG="/containers/apptainer/quast_5.2.0.sif"
READS="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads/Ms-0/ERR11437313.fastq.gz"
REF="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz"

FLYE_FA="$ASSEMBLY_DIR/flye/assembly.fasta"
HIFIASM_FA="$ASSEMBLY_DIR/hifiasm/asm.bp.p_ctg.fa"
LJA_FA="$ASSEMBLY_DIR/LJA/assembly.fasta"

LABELS="flye,hifiasm,lja"

REF_DIR="/data/courses/assembly-annotation-course/references"
REF="${REF_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz"
FEATURES="${REF_DIR}/Arabidopsis_thaliana.TAIR10.57.gff3"

# Optional argument: pass "useRef" to include reference and features
USE_REF=0
if [[ "${1:-}" == "useRef" ]]; then USE_REF=1; fi
if (( USE_REF )); then
    OUT_DIR="$OUT_DIR/with_ref"
else
    OUT_DIR="$OUT_DIR/no_ref"
fi

# Create output directory
mkdir -p "$OUT_DIR"

COMMON_ARGS=(
    --eukaryote \
    --threads $SLURM_CPUS_PER_TASK \
    --labels $LABELS \
    --est-ref-size 135000000 \
    --pacbio $READS \
    --no-sv \
    --large \
    -o $OUT_DIR
)

if (( USE_REF )); then
    # Run QUAST with reference and annotations
    apptainer run --bind /data $QUAST_IMG \
    quast $FLYE_FA $HIFIASM_FA $LJA_FA \
    ${COMMON_ARGS[@]} \
    -r $REF --features $FEATURES
else
    # Run QUAST without reference
    apptainer run --bind /data $QUAST_IMG \
    quast $FLYE_FA $HIFIASM_FA $LJA_FA \
    ${COMMON_ARGS[@]}
fi

