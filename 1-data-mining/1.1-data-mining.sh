#!/bin/bash

SRA=$1
outdir=$2


if [ -z $SRA ] || [ -z $outdir ];
  then
    echo "USAGE: 1-data-mining.sh <SRA-accession> <outdir>";
    exit 1;
fi

if [ -d $outdir ];
  then
      echo "outdir exists, the fastq files will be there";
  else
      echo "outdir $outdir doesn't exist, creating it"
      mkdir $outdir
fi

cd ./$outdir;

echo "This process may take a while, if unstable connection";
echo "with the server, try running it with screen -L";

start=$(date +%s);
fastq-dump --defline-qual "+" --split-files --gzip --clip $SRA;

end=$(date +%s);
DIFF=$(( $end - $start ));
echo "dumping is done;";
echo "execution time: $diff seconds";

fqlist=$( ls | grep "fastq");

for file in $fqlist;
    do
      #create name for file
      outbase=$( echo $file | cut -d '.' -f1 );
      echo "Processing the file $file";
      fastq-stats $file > $outbase".stats.txt";
done
echo "Done";

date;
