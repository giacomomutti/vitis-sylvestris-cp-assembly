#!/bin/bash

in1=$1
in2=$2
name=$3

if [[ -f $in1 && -f $in2 ]] && [[ $in1 == *f*q ]] && [[ $in2 == *f*q ]] && [[ ! -z $name ]];
  then
    echo "This script will use abyss assembler with k sizes: 17 31 63 81 96";
    echo "for each k value it will create a directory with the completed assembly"
    list=( 17 31 63 81 96 )
    for k in "${list[@]}";
    do
      mkdir k$k
      abyss-pe -C k$k name=$name_$k k=$k in="../$in1 ../$in2"
    done
    cat k*/*stats | grep "scaffold\|name" | awk -F "\t" 'BEGIN{OFS="\t"}{print $1, $3,$6, $10, $11}' | awk '!x[$0]++' > $name"_stats.txt"
    #abyss-fac k*/$name-contigs.fa
  else
    echo "USAGE: abyss-assembly.sh <R1.fastq> <R2.fastq> <name of assembly>"
    exit 1
fi
