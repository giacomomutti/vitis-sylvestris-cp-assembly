#!/bin/bash

ref=$1
R1=$2
R2=$3

#echo "USAGE: bam-to-ref.sh <ref.fasta> <R1.fastq> <R2.fastq>"
echo "This script only works with paired fastq files"


if [ -f $R1 ] && [ -f $R2 ] && [ -f $ref ] && [[ $R1 == *f*q ]] && [[ $R2 == *f*q ]] && [[ $ref == *f*a ]];
  then
    start=$(date +%s);
    echo "indexing the reference";
    bowtie2-build $ref ${ref%.*};
    echo "mapping to reference and creating bam file";
    bam=$(echo $R1 | cut -d '_' -f1)_mapped.bam;
    bowtie2 -p 8 -x ${ref%.*} -1 $R1 -2 $R2 | samtools view -bSF4 - > $bam;
    samtools sort -o $bam $bam;
    echo "obtaining bam stats";
    stats=${bam%.*}_stats.txt;
    samtools flagstat $bam > $stats;
    echo "The bam file has $(grep total $stats | cut -d ' ' -f1) reads";
    echo "$(grep properly $stats | cut -d ' ' -f1) of which properly paired";
    echo "extracting bam with only paired reads";
    paired=${bam%.bam}_paired.bam
    samtools view -u -f 3 -F 12 $bam > $paired;
    samtools sort -n $paired -o $paired;
    end=$(date +%s);
    DIFF=$(( $end - $start ));
    echo "execution time: $diff seconds";
    date;
    #indexing the bam would be useful?
  else
    echo "USAGE: bam-to-ref.sh <ref.fasta> <R1.fastq> <R2.fastq>"
    exit 1;
fi
