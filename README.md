# Genome-and-Transcriptome-Assembly
This repository contains the SLURM batch scripts I used to perform a full, container-based assembly and evaluation of an Arabidopsis thaliana accession for the course “Genome & Transcriptome Assembly and Annotation.”
The scripts run on an HPC with SLURM and Apptainer/Singularity and reproduce all steps from raw reads → assemblies → QC → dotplots.

**Goal**: de novo assemble a genome (HiFi) and transcriptome (RNA-seq), assess quality at multiple levels, and compare assemblies/against a reference.

## Pipeline Overview
1. **QC & filtering** of HiFi and RNA-seq reads (FastQC, fastp).
2. **k-mer profiling** (Jellyfish) for coverage/complexity checks.
3. **Genome assembly** with three long-read assemblers: Flye, hifiasm, LJA.
4. **Transcriptome assembly** with Trinity.
5. **Assembly evaluation** using three complementary tools:
    - **BUSCO** (biological completeness),
    - **QUAST** (contiguity + reference-based metrics),
    - **Merqury** (k-mer-based QV & completeness without a reference).
6. **Whole-genome alignments & dotplots** (NUCmer + mummerplot) against the A. thaliana reference and **pairwise assembly vs assembly**.

## Dataset
The datasets used originate from:
- Lian Q, et al. A pan-genome of 69 Arabidopsis thaliana accessions reveals a conserved genome structure throughout the global species range Nature Genetics. 2024;56:982-991. Available from: https://www.nature.com/articles/s41588-024-01715-9
- Jiao WB, Schneeberger K. Chromosome-level assemblies of multiple Arabidopsis genomes reveal hotspots of rearrangements with altered evolutionary dynamics. Nature Communications. 2020;11:1–10. Available from: http://dx.doi.org/10.1038/s41467-020-14779-y

## Repo Layout
```
scripts/
  00_dir_set_up.slurm           # create project folders
  01_run_fastQC.slurm           # FastQC on raw reads
  02_reads_filtering.slurm      # fastp trimming (RNA-seq) + copy HiFi
  03_run_fastQC_trimmed.slurm   # FastQC on trimmed reads
  04_kmer_counting.slurm        # Jellyfish k-mer histogram
  05_1_flye_assembly.slurm      # Flye genome assembly
  05_2_hifiasm_assembly.slurm   # hifiasm genome assembly
  05_3_LJA_assembly.slurm       # LJA genome assembly
  06_trinity_RNAseq_assembly.slurm
  07_1_busco_qual_assess.slurm  # BUSCO (array over genome+transcriptome)
  07_2_quast_qual_assess.slurm  # QUAST (with/without reference)
  07_3_merqury_qual_assess.slurm# Merqury (meryl + QV/completeness)
  08_genome_comparisons.slurm   # NUCmer/mummerplot dotplots
```
Outputs (created outside the repo by the scripts):
- assembly/ — final FASTAs + per-assembler logs, graphs
- assembly_QC/ — busco/, quast/with_ref|no_ref/, merqury/*
- genome_comparisons/ — .delta, .png dotplots for ref↔asm and asm↔asm
- reads_QC/ & reads_filt/ — QC reports and trimmed data
- kmer_counting/ — reads.histo for GenomeScope
- output/ — SLURM logs for grading/debugging

## Software
- FastQC v0.12.1
- fastp v0.24.1
- Jellyfish v2.2.6
- Flye v2.9.5
- Hifiasm v0.25.0
- LJA v0.2
- Trinity v2.15.1
- BUSCO v5.4.2
- QUAST v5.2.0
- Merqury v1.3
- NUCmer v4.0.0
- MUMer v4.0.0