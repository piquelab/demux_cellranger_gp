#!/bin/bash

set -v
set -e 

module load cellranger

mkdir -p ref
cd ref

if [ ! -f "Cavia_porcellus.Cavpor3.0.108.gtf" ]; then 
    wget "https://ftp.ensembl.org/pub/release-108/gtf/cavia_porcellus/Cavia_porcellus.Cavpor3.0.108.gtf.gz"
    gunzip  Cavia_porcellus.Cavpor3.0.108.gtf.gz
fi

if [ ! -f "Cavia_porcellus.Cavpor3.0.dna.toplevel.fa" ]; then 
    wget "https://ftp.ensembl.org/pub/release-108/fasta/cavia_porcellus/dna/Cavia_porcellus.Cavpor3.0.dna.toplevel.fa.gz"
    gunzip Cavia_porcellus.Cavpor3.0.dna.toplevel.fa.gz
fi


if [ ! -f "Cavia_porcellus.Cavpor3.0.108.filtered.gtf" ]; then 
 cellranger mkgtf \
   Cavia_porcellus.Cavpor3.0.108.gtf \
   Cavia_porcellus.Cavpor3.0.108.filtered.gtf \
   --attribute=gene_biotype:protein_coding
fi  

cellranger mkref \
  --genome=Cavpor3 \
  --fasta=Cavia_porcellus.Cavpor3.0.dna.toplevel.fa \
  --genes=Cavia_porcellus.Cavpor3.0.108.filtered.gtf \
  --nthreads=${SLURM_CPUS_ON_NODE} \
  --memgb=110
