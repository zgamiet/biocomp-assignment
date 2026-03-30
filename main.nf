#!/usr/bin/env nextflow

process FASTQC {
  publishDir "${params.outdir}", mode: 'copy', overwrite: true
  
  input:
    tuple val(id), path(reads)

  output:
    tuple val(id), path("*_fastqc*"), emit: fastqc_report
  script:
    """
    fastqc -t 2 $reads
    """
}

process TRIMMOMATIC {
  container 'users/user11/pipe-assignment/trim.sif'

  input:
    tuple val(id), path(reads)

  output:
    tuple val(id), path("trimmed_${id}_R1_paired.fq.gz"), path("trimmed_${id}_R2_paired.fq.gz"), emit: trim_fq
  script:
  """
  java -jar /opt/Trimmomatic-0.39/trimmomatic-0.39.jar PE \
        -threads 2 \
        $reads \
        trimmed_${id}_R1_paired.fq.gz trimmed_${id}_R1_unpaired.fq.gz \
        trimmed_${id}_R2_paired.fq.gz trimmed_${id}_R2_unpaired.fq.gz \
        ILLUMINACLIP:/opt/trimmomatic/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:50
  """
}

process BWA {

  input:
    path chr19
    tuple val(id), path(read1), path(read2)

  output:
    tuple val(id), path("${id}.sam*"), emit: bwa_sam
  script:
  """
    bwa mem -t 2 ${chr19}/chr19.fa $read1 $read2 > ${id}.sam
  """
}

process SAM2BAM {
  publishDir "${params.outdir}", mode: 'copy', overwrite: true

  input:
    tuple val(id), path(samfile)

  output:
    tuple val(id), path("${id}.bam"), emit: bam_file
  script:
    """
    samtools view -bS ${samfile} | samtools sort -o ${id}.bam
    """
}

process VARCALLING { 
  publishDir "${params.outdir}", mode: 'copy', overwrite: true

  input:
    path chr19
    tuple val(id), path(bam)

  output:
    tuple val(id), path("${id}.vcf.gz"), emit: variants

  script:
    """
    bcftools mpileup -f ${chr19} ${bam} | bcftools call -mv -Oz -o ${id}.vcf.gz
    bcftools index ${id}.vcf.gz
    """
}

workflow {
  def fastq = Channel.fromFilePairs(params.fastq)
  def output = Channel.fromPath(params.outdir)
  def bwa_genome = Channel.fromPath(params.chr19Folder)
  def bcf_genome = Channel.fromPath(params.chr19)

  FASTQC(fastq)
  TRIMMOMATIC(fastq)
  BWA(bwa_genome, TRIMMOMATIC.out.trim_fq)
  SAM2BAM(BWA.out.bwa_sam)
  VARCALLING(bcf_genome, SAM2BAM.out.bam_file) 
}
