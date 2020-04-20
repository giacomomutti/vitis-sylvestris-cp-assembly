#!/bin/bash
echo "To run this script Ragoo needs a pytho virtual environment!"
echo "this step is optional, it  depends on abyss scaffolding"

scaf=$1
ref=$2

if [ -f $scaf && -f $ref ] && [[ $scaf==f*a ]] && [[ $ref==f*a ]]; then
    echo "the script will use ragoo to try to reorder the scaffold";
    echo "a good result is not guaranteed and it higly depends on";
    echo "the scaffold and the level of divergence with the reference";
    ragoo.py $scaf $ref;
    echo "groupings and ordering stats of the ragoo output: see maual";
    cat ./ragoo_output/*/*txt;
    mv ./ragoo_output/ragoo.fasta ./ragoo_output/assembly.fasta;
    echo "your reorder assembly has these sequences:";
    cat ./ragoo_output/assembly.fasta | awk '$0 ~ ">" {if (NR > 1) {print c;} c=0;printf substr($0,2,100) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; }';
    date;
  else
    echo "USAGE: 8-ragoo.sh <scaffold.fasta> <ref.fasta>"
    exit 1
fi
