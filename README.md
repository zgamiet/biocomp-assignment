## Final Biocomputing Assignment 2026

**Trimmomatic definition file**

A singularity definition file that installs and runs Trimmomatic was created, later built into a sif image and was used in a pipeline workflow. 

The definition file (trim.def) pulls the trimmomatic file for Illumina NGS data from usadellab.org. The file contains the trimming tool as well as adapter information so that there is quality trimming and adapter clipping of sequencing reads. The trimmomatic tool offered by usadellab.org requires java to execute the trimmomatic-0.39.jar file. 

A singularity image was created from the definition file using the following command: <br>
> singularity build --fakeroot trim.sif trim.def

***
**Nextflow pipeline**

The pipeline was used to process raw sequencing reads to obtain a quality control report and a .vcf file containing variants. 

This pipeline features five process; Fastqc, Trimmomatic, BWA, SAM to Bam and VarCalling, which were applied to raw sequencing reads for desired outputs. 
The trim.sif image was used to perform the trimming of reads whereas with the other processes, the bio modules (fastqc, bwa, samtools and bcftools) were used. 
Example read data (SRR061646_SML) was supplied during coursework and alignment was done against a chromosome 19 reference (chr19.fa). 

The pipeline was performed with the following command: <br>
> ./run_pipe

Using the VCF file, the SNP variant at location chr19:90526 was selected for viewing. A subset of the BAM file was then created by obtaining the region flanking the variant of interest. The following commands were used in the terminal to achieve this:

> samtools view -b SRR061646_SML.bam 19:90426-90626 > subset.bam <br>
> samtools index subset.bam <br>

The generated index and pipeline output files were used to visualize a variant of interest in Integrative Genomics Viewer (IGV). The following is a snapshot of the variant centered in IGV with variant information:

<img width="1694" height="1121" alt="Screenshot (54)" src="https://github.com/user-attachments/assets/962b43f2-330e-4822-90b1-628c649a9ce1" />



***
**Database structure**

Data was first selected and sorted by columns of interest (chromosome (chrom), position (pos), reference allele (ref), alternative allele (alt) and quality (qual)). This information was extracted and then put into a table title 'vcf_data' in the SQLite3 database 'variants.db'. 

The following command was used to create table 'vcf_data' in SQLite3: <br>
> CREATE TABLE vcf_data ( <br>
    chrom TEXT, <br>
    pos INTEGER, <br>
    ref TEXT, <br>
    alt TEXT, <br>
    qual FLOAT <br>
); <br>
