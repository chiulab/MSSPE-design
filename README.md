## MSSPE (Metagenomic Sequencing with Spiked Primer Enrichment) Design Software v1.0

Last updated 10/23/19 Charles Chiu

#### Overview
This is a shell script that takes as input a multiple-sequenced aligned (MSA) FASTA file of reference sequences
and designs short primer sets (generally 11-17 nt) tiled across the entire sequence space, for use in the MSSPE protocol.

The MSSPE protocol has been published in Deng, et al., (2019) in the journal Nature Microbiology.

```
v1.0 - uses legacy BLASTALL (software used for the Deng, et al. 2019 paper)
```

This software has been tested in an Ubuntu 16.04.6 LTS Linux environment.

Main script: `MSSPE-design.sh` [OBFUSCATED]

#### Usage
`MSSPE-design.sh <MSA FASTA file> <kmer size> <segment_window> <overlap> <selection_window> <evalue> <dG> <dS> <numcores>`

```
*********************************************************************************************************************************
MSA FASTA file = multiple-sequenced aligned FASTA file
kmer size = kmer size (generally 11 - 17 nt)
segment_window = designated bp interval between forward and primer spiked primers (300-600 nt)
overlap = overlap in the tiled fragment windows (1/2 of the fragment window size, or 150-300 nt)
selection_window = size of window in bp from which forward and reverse primers will be selected (50 nt)
evalue = evalue for comparing forward and reverse primers by BLASTN (generally 0.1)
dG = "delta G", primer energy threshold cutoff in cals/mol (generally -9000)
dS = "delta S", cutoff for the number of minimum segments that need to be covered by each new primer (generally 0-10, depending
   on the number, diversity, and breadth of reference sequeces
*********************************************************************************************************************************
```

Software package dependencies:
1. [pyfasta](https://github.com/brentp/pyfasta) (included with software package under MIT license

2. NCBI BLAST 2.7.1+ package (requires blastn and makeblastdb)
3. Python v2.7.12
4. Perl v5.22.1
5. [ntthal](https://manpages.debian.org/testing/primer3/ntthal.1.en.html) from Primer3 package

Additional required scripts:
1. annotateTm.py
2. iterate_checkdimer.sh [OBFUSCATED]
3. kmer_count_fasta_top50.pl

Please note that the key scripts "MSSPE-design.sh" and "iterate_checkdimer.sh" have been obfuscated. Please contact Dr. Charles Chiu, University of California, San Francisco (UCSF)  at charles.chiu@ucsf.edu if you would like to make changes or improvements to the script.

```
******************************************************************************************************************************
Sample Test File:
1. ZIKV-96seqs.fasta

    To run with 8 cores, type "MSSPE-design.sh ZIKV-96seqs.fasta 13 500 250 50 0.1 2 -9000 8" from the command line.
******************************************************************************************************************************
```

# Hardware & Software Requirements
* Linux server, tested Ubuntu 16.04 with 512 GB memory, 18 TB shared disk volume

# Additional Software Dependencies
* Python interpreter, tested Python v2.7.12
* Perl interpreter, tested Perl v5.22.1

# Required Scripts
* MSSPE-design.sh [OBFUSCATED]
* iterate_checkdimer.sh [OBFUSCATED]
* annotateTm.py
* kmer_count_fasta_top50.pl

# Instructions for Running the MSSPE Design Software

1. Generate a multiple-sequenced aligned (MSA) FASTA file (using "-" to denote gaps in the alignment). Available software tools include [MAFFT](https://mafft.cbrc.jp/alignment/software/), accessed October 2019, [MUSCLE](https://www.ebi.ac.uk/Tools/msa/muscle/), accessed October 2019, and several others.
2. Run the `MSSPE-design.sh` script:

`MSSPE-design.sh <MSA FASTA file> <kmer size> <segment_window> <overlap> <selection_window> <evalue> <dG> <dS> <numcores>`

```
*************************************************************************************
• MSA FASTA file = multiple-sequenced aligned FASTA file
• kmer size = kmer size (generally 11 - 17 nucleotides / nt)
• segment_window = designated bp interval between forward and primer spiked primers (300-600 nt)
• overlap = overlap in the tiled fragment windows (1/2 of the fragment window size, or 150-300 nt)
• selection_window = size of window in bp from which forward and reverse primers will be selected (50 nt)
• evalue = evalue for comparing forward and reverse primers by BLASTN (generally 0.1)
• dG = "delta G", primer energy threshold cutoff in cals/mol (generally -9000)
• dS = "delta S", cutoff for the number of minimum segments that need to be covered by each new primer (generally 0-10, depending on the number, diversity, and breadth of reference sequences
• numcores = number of available cores on your computer
*********************************************************************************************************************************
```

# Test Run
1. A sample test file named `ZIKV-96seqs.fasta` is provided, which generates MSSPE spiked primers based on 96 ZIKV reference genomes in the NCBI (National Center for Biotechnology Information) GenBank database 
2. Run the `MSSPE-design.sh` script from the command line with the following parameters (using 8 cores):

	`MSSPE-design.sh ZIKV-96seqs.fasta 13 500 250 50 0.1 2 -9000 8`

3. The MSSPE ZIKV primer sequences in FASTA format can be found in 

	`ZIKV_96seqs.nospace.forward.13mers.fasta`
	`ZIKV_96seqs.nospace.reverse.13mers.fasta`

   and summary statistics can be found in:

	`summary_statistics_ZIKV-96seqs.13mers.txt`
