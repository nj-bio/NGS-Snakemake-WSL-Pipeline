configfile: "config/config.yaml"

SAMPLES = config["samples"]
REF = config["reference"]

rule all:
    input:
        "results/multiqc/multiqc_report.html",
        expand("results/bam/{sample}.sorted.bam.bai", sample=SAMPLES)

# --------------------
# FastQC
# --------------------
rule fastqc:
    input:
        r1="data/raw/{sample}_R1.fastq"
    output:
        "results/fastqc/{sample}_R1_fastqc.zip"
    shell:
        """
        fastqc {input.r1} -o results/fastqc
        """

# --------------------
# Alignment
# --------------------
rule align:
    input:
        ref=REF,
        r1="data/raw/{sample}_R1.fastq"   
    output:
        "results/alignment/{sample}.sam"
    shell:
        """
        bwa mem {input.ref} {input.r1}  > {output}
        """

# --------------------
# SAM → BAM
# --------------------
rule sam_to_bam:
    input:
        "results/alignment/{sample}.sam"
    output:
        "results/bam/{sample}.bam"
    shell:
        """
        samtools view -Sb {input} > {output}
        """

# --------------------
# Sort BAM
# --------------------
rule sort_bam:
    input:
        "results/bam/{sample}.bam"
    output:
        "results/bam/{sample}.sorted.bam"
    shell:
        """
        samtools sort {input} -o {output}
        """

# --------------------
# Index BAM
# --------------------
rule index_bam:
    input:
        "results/bam/{sample}.sorted.bam"
    output:
        "results/bam/{sample}.sorted.bam.bai"
    shell:
        """
        samtools index {input}
        """

# --------------------
# Alignment QC
# --------------------
rule flagstat:
    input:
        "results/bam/{sample}.sorted.bam"
    output:
        "results/qc/{sample}.flagstat.txt"
    shell:
        """
        samtools flagstat {input} > {output}
        """

# --------------------
# MultiQC
# --------------------
rule multiqc:
    input:
        expand("results/fastqc/{sample}_R1_fastqc.zip", sample=SAMPLES),
        expand("results/qc/{sample}.flagstat.txt", sample=SAMPLES)
    output:
        "results/multiqc/multiqc_report.html"
    shell:
        """
        multiqc results -o results/multiqc
        """


