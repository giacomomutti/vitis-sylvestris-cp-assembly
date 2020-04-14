#!/bin/bash
bam=$1
R1=$2
R2=$3

if [ -f $bam ] && [[ $R1 == *f*q ]] && [[ $R2 == *f*q ]] && [[ $bam == *bam ]];
    then
      start=$(date +%s);
      echo "Extracting fastq files";
      bamToFastq -i $bam -fq $R1 -fq2 $R2;
      for file in $R1 $R2
        do
          echo "getting the stats for $file";
          fastq-stats $file > ${file%.*}.stats.txt;
          echo "Done";
        done
        pair=$(samtools flagstat $bam | grep properly | cut -d ' ' -f1);
        single_R1=$(grep reads ${R1%.*}.stats.txt | cut -f2);
        single_R2=$(grep reads ${R2%.*}.stats.txt | cut -f2);
      if [[ single_R1==single_R2 ]] && (( $pair / $single_R1 == 2 ))
        then
          echo "Your fastq files have $single_R1 reads each.";
        else
          echo "Something went wrong, the reads are not equally distributed"
      fi
      end=$(date +%s);
      DIFF=$(( $end - $start ));
      echo "execution time: $diff seconds";
      date;
    else
          echo "USAGE: bam-to-fastq.sh <bam> <out_R1.fastq> <out_R2.fastq>";
          exit 1;
fi
