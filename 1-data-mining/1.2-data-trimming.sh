#!/bin/bash


#adapters= <set location of the adapters>

echo "Adapters found in $adapters";

echo "This script works only for paired reads, the fastq can be zipped";

R1=$1
R2=$2

if [ -f $R1 ] && [ -f $R2 ] && [[ $R1 == *f*q ]] && [[ $R2 == *f*q ]];
  then
    echo "Trimming adapters and filtering low-quality reads";
    echo "Removing bases with q<15, 4-mers with mean quality<20 and reads";
    echo "long less than 60bp after trimming.";
    echo "All reads will remain paired after trimming";
    start=$(date +%s);
    fastq-mcf $adapters $R1 $R2 -q 15 -l 60 --qual-mean 20 -w 4 -o $(echo $R1 | cut -d '.' -f1)_trimmed.fastq.gz -o $(echo $R2 | cut -d '.' -f1)_trimmed.fastq.gz;
    end=$(date +%s);
    DIFF=$(( $end - $start ));
    echo "done";
    echo "execution time: $diff seconds";
    echo "creating a stats file for each trimmed fastq"
    for trimmed in $(ls | grep trimmed);
      do
        echo "processing file: $trimmed"
        fastq-stats $trimmed > $(echo $trimmed | cut -d '.' -f1).stats.txt;
      done
    date
  else
    echo "USAGE: 2-trimming.sh <R1.fastq> <R2.fastq>";
    exit 1;
fi
