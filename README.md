## Final Biocomputing Assignment 2026

**Trimmomatic definition file**

A singularity definition file that installs and runs Trimmomatic was created, later built into a sif image and was used in a pipeline workflow. 

The definition file (trim.def) pulls the trimmomatic file for Illumina NGS data from usadellab.org. The file contains the trimming tool as well as adapter information so that there is quality trimming and adapter clipping of sequencing reads. The trimmomatic tool offered by usadellab.org requires java to execute the trimmomatic-0.39.jar file. 

A singularity image (trim.sif) was created from the definition file using -fakeroot.

***
**Nextflow pipeline**

The pipeline was used to process raw sequencing reads to obtain a quality control report and a .vcf file containing variants. 

This pipeline features five process; Fastqc, Trimmomatic, BWA, SAM to Bam and VarCalling, which were applied to raw sequencing reads for desired outputs. 
The trim.sif image was used to perform the trimming of reads whereas with the other processes, the bio modules (fastqc, bwa, samtools and bcftools) were used. 
Example read data (SRR061646_SML) was supplied during coursework and alignment was done against a chromosome 19 reference (chr19.fa). 

Using the VCF file, the SNP variant at location chr19:90526 was selected for viewing. A subset of the BAM file was then created by obtaining the region flanking the variant of interest. The following commands were used in the terminal to achieve this:

> samtools view -b SRR061646_SML.bam 19:90426-90626 > subset.bam <br>
> samtools index subset.bam <br>

Index and pipleine output files were used to visualize a variant of interest in Integrative Genomics Viewer (IGV).

<img width="1348" height="901" alt="Screenshot (55)" src="https://github.com/user-attachments/assets/5282b5af-5b50-4a39-9fe4-05bbcf0a9781" />
Figure 1. Selected SNP variant viewed in IGV. 

***
**Database structure**

Data was first selected and sorted by columns of interest (chromosome (chrom), position (pos), reference allele (ref), alternative allele (alt) and quality (qual)). This information was extracted and then put into a table title 'vcf_data' in the SQLite3 database 'variants.db'. 
