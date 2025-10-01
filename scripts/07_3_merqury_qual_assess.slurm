#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=merqury_qual_assess
#SBATCH --output=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/merqury_qual_assess_output_%j.o
#SBATCH --error=/data/users/aschmid/Genome-and-Transcriptome-Assembly/output/merqury_qual_assess_error_%j.o

ASSEMBLY_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly"
OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly_QC/quast"
MERQURY_IMG="/containers/apptainer/merqury_1.3.sif"

READS="/data/users/aschmid/Genome-and-Transcriptome-Assembly/reads/Ms-0/ERR11437313.fastq.gz"

FLYE_FA="$ASSEMBLY_DIR/flye/assembly.fasta"
HIFIASM_FA="$ASSEMBLY_DIR/hifiasm/asm.bp.p_ctg.fa"
LJA_FA="$ASSEMBLY_DIR/LJA/assembly.fasta"

OUT_DIR="/data/users/aschmid/Genome-and-Transcriptome-Assembly/assembly_QC/merqury"

mkdir -p $OUT_DIR

apptainer exec --bind /data --bind /usr/bin/ln:/bin/ln $MERQURY_IMG bash -lc '
    export MERQURY="/usr/local/share/merqury"

    OUT_DIR="'"$OUT_DIR"'"
    READS="'"$READS"'"
    SLURM_CPUS_PER_TASK="'"$SLURM_CPUS_PER_TASK"'"

    FLYE_FA="'"$FLYE_FA"'"
    HIFIASM_FA="'"$HIFIASM_FA"'"
    LJA_FA="'"$LJA_FA"'"

    K="$("${MERQURY}/best_k.sh" 135000000 | tail -n1 | awk '\''{print int($1+0.5)}'\'')"
    echo "Using k=$K" | tee "$OUT_DIR/k.txt"

    READ_DB="${OUT_DIR}/reads.k$K.meryl"
    if [ ! -d $READ_DB ]; then
        meryl count k=$K threads=$SLURM_CPUS_PER_TASK output $READ_DB $READS
    fi

    run_merqury () {
        mkdir -p $OUT_DIR/$2_k$K
        cd $OUT_DIR/$2_k$K
        echo $2

        $MERQURY/merqury.sh $READ_DB $1 $2
    }

    run_merqury $FLYE_FA 'flye'
    run_merqury $HIFIASM_FA 'hifiasm'
    run_merqury $LJA_FA 'lja'
'