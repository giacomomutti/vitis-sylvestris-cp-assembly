#!/bin/bash

R1=$1
R2=$2

est_size=161000
len=150

#100 200 500
list=( 10 50 )
echo "default estimated size is 161Kb and length of reads is 150";
echo "target coverages are: 10 50 100 200 500";

if [ -f $R1 ] && [ -f $R2 ] && [[ $R1 == *f*q ]] && [[ $R2 == *f*q ]];
  then
    for cov in "${list[@]}";
      do
        mkdir $cov"X_sample";
        cd ./$cov"X_sample";
        sample=$(( $est_size * $cov / $len / 2 ));
        seqtk sample ../$R1 $sample > ${R1%.*}_$cov"X.fq";
        seqtk sample ../$R2 $sample > ${R2%.*}_$cov"X.fq";
        cd ..
      done
  else
    echo "USAGE: dataset-generator.sh <R1.fastq> <R2.fastq>"
    exit 1
fi
