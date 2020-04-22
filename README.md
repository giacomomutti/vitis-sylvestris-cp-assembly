# *Vitis sylvestris* chloroplast assembly
## Abstract
Chloroplast genomes are a valuable resource for phylogenetic analyses, population genetics and species identification. 
Studying the chloroplast genome of wild grape (*Vitis vinifera subsp. sylvestris*) may shed light on the genomic 
effects of domestication. Here the complete wild grape chloroplast genome is assembled with Illumina reads deposited 
in the Sequence Read Archive (SRA) using the ABySS assembler. This approach, despite the inherent disadvantages of short-reads,
may offer good results rapidly if the possible parameters for the assembly are thoroughly explored. The genome is 160,184bp in 
length with a 100bp uncertain region and it has the typical quadripartite structure common in angiosperms.

## Methods

### 1-Data-mining
1. download raw data from SRA accession.
2. trim and quality filtering of the reads
3. map to reference chloroplast
4. extract reads mapped and properly paired

### 2-assembly
1. generates 10X, 50X, 100X, 200x samples
2. run abyss with k=32, 48, 64, 80, 96
3. data-viz of results
4. use ragoo if necessary to reorder scaffold

### 3-assembly evaluation
1. obtain stats to evaluate final assembly
2. data-viz of results
