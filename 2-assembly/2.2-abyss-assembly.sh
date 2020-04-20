#!/bin/bash

in1=$1
in2=$2
name=$3

if [[ -f $in1 && -f $in2 ]] && [[ $in1 == *f*q ]] && [[ $in2 == *f*q ]] && [[ ! -z $name ]];
  then
    echo "This script will use abyss assembler with k sizes: 32 48 64 80 96";
    echo "for each k value it will create a directory with the completed assembly"
    echo "the contigs shorter than 500bp will be filtered out!"
    list=( 32 48 64 80 96 )
    for k in "${list[@]}";
    do
      mkdir k$k
      abyss-pe -C k$k name=$name"_k"$k k=$k in="../$in1 ../$in2"
      seqtk seq -L 500 k$k/$name"_k"$k"-scaffolds.fa" > k$k/$name"_k"$k"-filtered-scaffolds.fa"
    done
    cat k*/*stats | grep "scaffold\|name" | awk -F "\t" 'BEGIN{OFS="\t"}{print $2, $3, $4, $6, $9, $10, $11}' | awk '!x[$0]++' > $name"_stats.txt"
    #abyss-fac k*/$name-contigs.fa
  else
    echo "USAGE: 6-abyss-assembly.sh <R1.fastq> <R2.fastq> <name of assembly>"
    exit 1
fi
