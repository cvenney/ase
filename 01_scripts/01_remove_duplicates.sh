#!/bin/bash
# srun -c 4 --mem 80G -p medium --time 3-00:00:00 -J dedup -o dedup_%j.log ./01_scripts/01_remove_duplicates.sh &
# 1 CPU
# 100 Go

# from Eric's bwa-meth_pipeline
# bams should be sorted

# Global variables
MARKDUPS="/prg/picard-tools/1.119/MarkDuplicates.jar"
ALIGNEDFOLDER="03_bams"
DEDUPFOLDER="04_dedup"
METRICSFOLDER="04_dedup/metrics"
NCPUS=4

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_logfiles"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Load needed modules
module load java/jdk/1.8.0_102

## Remove duplicates from bam alignments
#ls -1 "$ALIGNEDFOLDER"/*.bam |
#while read file
#do
#    echo "Deduplicating sample $file"

#    java -jar "$MARKDUPS" \
#        INPUT="$file" \
#        OUTPUT="$DEDUPFOLDER"/$(basename "$file" .bam).dedup.bam \
#        METRICS_FILE="$METRICSFOLDER"/$(basename "$file" .bam).metrics.txt \
#        VALIDATION_STRINGENCY=SILENT \
#        REMOVE_DUPLICATES=true
#done



# Remove duplicates from bam alignments with Gnu Parallel
ls -1 "$ALIGNEDFOLDER"/*.bam |
parallel -j 5 --tmpdir tmpdir \
    java -jar "$MARKDUPS" \
    INPUT={} \
    OUTPUT="$DEDUPFOLDER"/{/.}.dedup.bam \
    METRICS_FILE="$METRICSFOLDER"/{/.}.metrics.txt \
    VALIDATION_STRINGENCY=SILENT \
    REMOVE_DUPLICATES=true \; echo
