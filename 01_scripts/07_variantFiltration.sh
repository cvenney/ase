#!/bin/bash
# 07_variantFiltration.sh
# srun -c 1 --mem 30G -p small --time 1-00:00:00 -J variantFiltration -o 07_variantFiltration_%j.log ./01_scripts/07_variantFiltration.sh &

GENOMEFOLDER="02_reference"
GENOME="genome_M.fa"
SNPFOLDER="08_called_SNPs"

# Load needed modules
module load java/jdk/1.8.0_102 gatk/4.1.4.1 bcftools
	
for i in $(ls -1 "$SNPFOLDER"/*.raw.vcf | cut -d "." -f1)
    do
	  gatk VariantFiltration -R 02_reference/genome_M.fa -V $i.raw.vcf --cluster-window-size 35 --cluster-size 3 --filter-name QD2 --filter-expression "QD < 2.0" -O $i.withfilters.vcf
done

for i in $(ls -1 "$SNPFOLDER"/*.withfilters.vcf | cut -d "." -f1)
    do
    awk '{if ($1 ~ /^#/ ){print}
	  else if ($7 == "PASS" && length($4) == 1 && length($5) == 1){print} }' $i.withfilters.vcf |
	  bgzip > $i.filteredSNPs.vcf.gz
done

# index and merge vcf files
ls -1 "$SNPFOLDER"/*.filteredSNPs.vcf.gz > "$SNPFOLDER"/vcf.list
cat "$SNPFOLDER"/vcf.list | while read i; do bcftools index $i ; done
bcftools merge "$SNPFOLDER"/*.filteredSNPs.vcf.gz -o "$SNPFOLDER"/mergedSNPs.vcf