#!/bin/bash

SRA=$1
outdir=$2


if [ -z $SRA ] || [ -z $outdir ];
  then
    echo "USAGE: data-mining.sh <SRA-accession> <outdir>";
    exit 1;
fi

if [ -d $outdir ];
  then
      echo "outdir exists, the fastq files will be there";
  else
      echo "outdir $outdir doesn't exist, creating it"
      mkdir $outdir
fi

cd ./$outdir

echo "This process may take a while, if unstable connection"
echo "with the server, try running it with screen -L"

fastq-dump --defline-qual "+" --split-files --gzip --clip $SRA;

echo "dumping is done"

fqlist=$( ls | grep "fastq")
for file in $fqlist
    do
      #create name for file
      outbase=$( echo $file | cut -d '.' -f1 );
      echo "Processing the file $file";
      fastq-stats $file > $outbase".stats.txt";
      echo "Done";
done

date;
