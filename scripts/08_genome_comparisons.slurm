#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=genome_comparisons
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/genome_comparisons_output_%A_%a.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/genome_comparisons_error_%A_%a.o
#SBATCH --array=0-5

ASSEMBLY_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/genome_comparisons"
MUMMER_IMG="/containers/apptainer/mummer4_gnuplot.sif"
REF_DIR="/data/courses/assembly-annotation-course/references"

REF="${REF_DIR}/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
FLYE_FA="$ASSEMBLY_DIR/flye/assembly.fasta"
HIFIASM_FA="$ASSEMBLY_DIR/hifiasm/asm.bp.p_ctg.fa"
LJA_FA="$ASSEMBLY_DIR/LJA/assembly.fasta"

FAS=($REF $FLYE_FA $HIFIASM_FA $LJA_FA)
NAMES=('ref' 'flye' 'hifiasm' 'LJA')

PAIRS=(
    0 1 #   ref vs flye
    0 2 #   ref vs hifiasm
    0 3 #   ref vs lja
    1 2 #   flye vs hifiasm
    1 3 #   flye vs lja
    2 3 #   hifiasm vs lja
)

i=${SLURM_ARRAY_TASK_ID:-0}
A=${PAIRS[$(( i*2 ))]}
B=${PAIRS[$(( i*2 + 1 ))]}

PREFIX=${NAMES[A]}_vs_${NAMES[B]}

mkdir -p $OUT_DIR
cd $OUT_DIR

# ------ Comparing pair ------

apptainer exec --bind /data $MUMMER_IMG \
nucmer --prefix=$PREFIX --breaklen 1000 --mincluster 1000 \
${FAS[A]} ${FAS[B]}

apptainer exec --bind /data $MUMMER_IMG \
mummerplot --prefix=$PREFIX --filter --fat --large --layout -t png \
-R ${FAS[A]} \
-Q ${FAS[B]} \
$PREFIX.delta