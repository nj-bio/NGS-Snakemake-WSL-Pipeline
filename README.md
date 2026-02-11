# NGS Snakemake Pipeline (WSL)

## Overview
This project implements a reproducible NGS analysis pipeline using Snakemake in a WSL (Ubuntu) environment.

The pipeline performs:

- Quality Control using FastQC
- Read alignment using BWA-MEM
- SAM to BAM conversion using Samtools
- Sorting and indexing of BAM files
- Alignment statistics using samtools flagstat
- MultiQC report generation

## Tools Used

- Snakemake
- FastQC
- MultiQC
- BWA
- Samtools
- Conda (environment management)
- WSL Ubuntu (Linux)

## Project Structure

ngs_pipeline/
├── config/
│   └── config.yaml
├── ref/
│   └── genome.fa
├── data/raw/
├── results/
├── Snakefile
└── .gitignore

## How to Run

conda activate ngs
snakemake --cores 4

## Output

- FastQC reports: results/fastqc/
- BAM files: results/bam/
- Alignment stats: results/qc/
- MultiQC report: results/multiqc/multiqc_report.html

## Author
Nikita Jadhav  
MSc Bioinformatics
