#!/bin/bash
# 04_realign_indels.sh
# srun -c 4 --mem 40G -p medium --time 3-00:00:00 -J indel_realign -o 04_indel_realign_%j.log ./01_scripts/04_realign_indels.sh &
# from Eric's WGS prep pipeline (https://github.com/enormandeau/wgs_sample_preparation/blob/master/)

# Global variables
SPLIT="05_split"
REALIGN="06_realigned"
GENOMEFOLDER="02_reference"
GENOME="genome_M.fa"

# Load needed modules
module load java/jdk/1.8.0_102 gatk/3.8-1-0

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Realign around target previously identified
#ls -1 "$DEDUPFOLDER"/*dedup.bam |
#while read file
#do
#    java -jar $GATK \
#        -T IndelRealigner \
#        -R "$GENOMEFOLDER"/"$GENOME" \
#        -I "$file" \
#        -targetIntervals "${file%.dedup.bam}".intervals \
#        --consensusDeterminationModel USE_READS  \
#        -o "$REALIGNFOLDER"/$(basename "$file" .dedup.bam).realigned.bam
#done

# Realign around target previously identified in parallel
ls -1 "$SPLIT"/*.split.bam | cut -d "." -f1 |
    parallel -j 4 gatk -T IndelRealigner -R "$GENOMEFOLDER"/"$GENOME" -I {}.split.bam -targetIntervals {}.split.bam.intervals --consensusDeterminationModel USE_READS  -o "$REALIGN"/{/}.realigned.bam