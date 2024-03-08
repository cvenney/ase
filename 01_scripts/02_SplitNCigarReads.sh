#!/bin/bash
#02_SplitNCigarReads.sh
# srun -c 1 --mem 40G -p medium --time 3-00:00:00 -J split -o 02_split_%j.log ./01_scripts/02_SplitNCigarReads.sh &
# https://sites.google.com/a/broadinstitute.org/legacy-gatk-documentation/methods-and-algorithms/3891-Calling-variants-in-RNAseq
# don't need to use GATK RassignOneMapping Quality - Kyle set good alignments to MAPQ=60 in STAR

DEDUP="04_dedup"
OUTPUT="05_split"
GENOME="02_reference/genome_M.fa"

# PICARD="/prg/picard-tools/1.119/CreateSequenceDictionary.jar"
# java -jar "$PICARD" \
		# R=02_reference/genome_M.fa \
		# O=02_reference/genome_M.dict

module load java/jdk/1.8.0_102 gatk/3.8-1-0

# index dedup bams
for i in $(ls -1 "$DEDUP"/*.bam) 
do
	samtools index -b $i "$i".bai
done

# SplitNCigarReads
for i in $(ls -1 "$DEDUP"/*.bam | cut -d "." -f1)
do
	gatk -T SplitNCigarReads \
		-U ALLOW_N_CIGAR_READS  \
		-R "$GENOME" \
		-I $i.*.bam \
		-o "$OUTPUT"/$(basename $i).split.bam
done