## Final Biocomputing Assignment 2026

**Trimmomatic definition file**

A singularity definition file that installs and runs Trimmomatic was created, later built into a sif image and used in a pipeline workflow. 

The definition file (trim.def) pulls the trimmomatic file for Illumina NGS data from usadellab.org. The file contains the trimming tool as well as adapter information so that there is quality trimming and adapter clipping of sequencing reads. The trimmomatic tool offered by usadellab.org requires java to execute the trimmomatic-0.39.jar file. 

A singularity image (trim.sif) was created from the definition file using -fakeroot.

***
**Nextflow pipeline**

The pipeline is used to process raw sequencing reads to obtain a quality control report and a .vcf file containing variants. 

This pipeline features five process; Fastqc, Trimmomatic, BWA, SAM to Bam and VarCalling, which is applied to raw sequencing reads for desired outputs. 
The trim.sif image was used to perform the trimming of reads whereas with the other processes, the bio modules (fastqc, bwa, samtools and bcftools) were used.
Example read data was supplied during coursework and alignment was done against a chromosome 19 reference. The generated output files and index files were used to visualize variants of interest in Integrative Genomics Viewer (IGV).

***
**Database structure**
Data was first selected and sorted by columns of interest (chromosome, position, reference allele, alternative allele and quality). 
