#!/bin/bash

scaf=$1
outbam=$2
R1=$3
R2=$4

if [[ -f $scaf && -f $R2 && -f $R1 ]] && [[ $R1 == *f*q* ]] && [[ $R2 == *f*q* ]] && [[ $scaf == *f*a ]];
  then
    start=$(date +%s);
    out=${scaf%.*}
    echo "indexing the assembly";
    bowtie2-build $scaf $out;
    echo "mapping to assembly and creating bam file";
    bam=$outbam".bam";
    bowtie2 -p 8 -x $out -1 $R1 -2 $R2 | samtools view -bSF4 - > $bam;
    samtools sort -o $bam $bam;
    samtools faidx $scaf;
    bedtools genomecov -d -ibam $bam -g $scaf".fai" > $out".covbed.txt";
    samtools index $bam;
    freebayes -v $out".vcf" -b $bam -f $scaf;
    echo "there are a total of $(grep -v "#" $out".vcf" | wc -l) variants";
    echo "divided as:";
    echo $(grep -v "#" $out".vcf" | cut -f8 | sed -r 's/.+;TYPE=//' | sort | uniq -c);
    date;
  else
    echo "USAGE: 9-assebly-evaluation.sh <assembly.fasta> <outbam> <R1.fastq> <R2.fastq>"
    exit 1
fi
