#!/bin/bash
# 06_haplotypeCaller.sh
# srun -c 8 --mem 80G -p large --time 21-00:00:00 -J haplotypeCaller -o 06_haplotypeCaller_%j.log ./01_scripts/06_haplotypeCaller.sh &

GENOMEFOLDER="02_reference"
GENOME="genome_M.fa"
BQSR="07_bqsr"
SNPs="08_called_SNPs"

# Load needed modules
module load java/jdk/1.8.0_102 gatk/4.1.4.1

#ls "$BQSR"/*.bam > "$BQSR"/bam.list

ls -1 "$BQSR"/*.bam | cut -d "." -f1 | cut -d "/" -f2 | 
    parallel -j 4 gatk HaplotypeCaller \
	-R "$GENOMEFOLDER"/"$GENOME" \
	-I "$BQSR"/{}.bqsrfiltered.bam \
	--dont-use-soft-clipped-bases \
	--standard-min-confidence-threshold-for-calling 20.0 \
	-O "$SNPs"/{}.raw.vcf