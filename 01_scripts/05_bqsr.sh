#!/bin/bash
# srun -c 4 --mem 40G -p small --time 1-00:00:00 -J bqsr -o 05_bqsr_%j.log ./01_scripts/05_bqsr.sh &

#https://gatk.broadinstitute.org/hc/en-us/articles/360035890531-Base-Quality-Score-Recalibration-BQSR-
#https://gatk.broadinstitute.org/hc/en-us/articles/360036898312-BaseRecalibrator
#https://sites.google.com/a/broadinstitute.org/legacy-gatk-documentation/methods-and-algorithms/3891-Calling-variants-in-RNAseq


# Global variables
REALIGN="06_realigned"
GENOMEFOLDER="02_reference"
GENOME="genome_M.fa"
BQFOLDER="07_bqsr"
VARIANTS="known_variants.vcf"

# Load needed modules
module load java/jdk/1.8.0_102 gatk/4.1.4.1

# Realign around target previously identified in parallel
ls -1 "$REALIGN"/*.realigned.bam | cut -d "." -f1 | 
    parallel -j 4 gatk BaseRecalibrator \
   -I "$REALIGNEDFOLDER"{}.realigned.bam \
   -R "$GENOMEFOLDER"/"$GENOME" \
   --known-sites "$BQFOLDER"/"$VARIANTS" \
   -O {}.bsqr_recal_data.table
   
ls -1 "$REALIGN"/*.realigned.bam | cut -d "." -f1 | 
	parallel -j 4 gatk ApplyBQSR \
	-R "$GENOMEFOLDER"/"$GENOME" \
	-I "$REALIGNEDFOLDER"{}.realigned.bam \
	-bqsr-recal-file {}.bsqr_recal_data.table \
	-O "$BQFOLDER"/{/}.bqsrfiltered.bam