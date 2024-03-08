#!/bin/bash
# 03_indel_targets.sh
# srun -c 4 --mem 100G -p medium --time 3-00:00:00 -J indel_targets -o 03_indel_targets_%j.log ./01_scripts/03_indel_targets.sh &
# from Eric's WGS prep pipeline (https://github.com/enormandeau/wgs_sample_preparation/blob/master/01_scripts/07_gatk_realign_targets.sh)

# Global variables
#GATK="/home/clrou103/00-soft/GATK/GenomeAnalysisTK.jar"
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
LOG_FOLDER="99_logfiles"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Build Bam Index
#ls -1 "$SPLIT"/*dedup.bam |
#while read file
#do
#    java -jar "$GATK" \
#        -T RealignerTargetCreator \
#        -R "$GENOMEFOLDER"/"$GENOME" \
#        -I "$file" \
#        -o "${file%.dedup.bam}".intervals
#done

# Build Bam Index
ls -1 "$SPLIT"/*.split.bam |
    parallel -j 4 gatk -T RealignerTargetCreator -R "$GENOMEFOLDER"/"$GENOME" -I {} -o {}.intervals