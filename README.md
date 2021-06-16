# Genome to Proteome Alignment

## Mandatory parameters

 * `--target`: path to one proteome file in FASTA format.

   — or —

   `--input`: path to a sample sheet in tab-separated format with one header
   line `id	file`, and one row per proteome (ID and path to FASTA file).


 * `--query`: path to one genome file in FASTA format.

## Options

 * `--lastdb_args` defaults to `-q -c -R01` , like in the
   [LAST cookbook](https://gitlab.com/mcfrith/last/-/blob/main/doc/last-cookbook.rst).

 * `--train_args` defaults to `--codon -X1` .

 * `--lastal_args` defaults to `-D1e9 -m100 -K1` .

 * `--format` defaults to `gff` . Can be converted to a standard GFF with a custom script
   and uploaded to ZENBU for viewing. 


## Fixed arguments

 * `--revsym` is hardcoded the call to `last-train` as the DNA strands
   play equivalent roles in the studied genomes.

## Test

### test remote

    nextflow run oist/plessy_pairwiseGenomeComparison -r main -profile oist --input testInput.tsv --target https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/illumina/fasta/contigs.fasta
    nextflow run oist/plessy_pairwiseGenomeComparison -r main -profile oist --query https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/genome/genome.fasta --target https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/illumina/fasta/contigs.fasta

### test locally

    nextflow run ./main.nf -profile oist --input testInput.tsv --target https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/illumina/fasta/contigs.fasta
    nextflow run ./main.nf -profile oist --query https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/genome/genome.fasta --target https://raw.githubusercontent.com/nf-core/test-datasets/modules/data/genomics/sarscov2/illumina/fasta/contigs.fasta


## Advanced use

### Override computation limits

Computation resources allocated to the processe are set with standard _nf-core_
labels in the [`nextflow.config`](./nextflow.config) file of the pipeline.  To
override their value, create a configuration file in your local directory and
add it to the run's configuration with the `-c` option.

For instance, with file called `overrideLabels.nf` containing the following:

```
process {
  withLabel:process_high {
    time = 3.d
  }
}
```

The command `nextflow -c overrideLabels.nf run …` would set the execution time
limit for the training and alignment (whose module declare the `process_high`
label) to 3 days instead of the 1 hour default.


## Semantic versioning

I will apply [semantic versioning](https://semver.org/) to this pipeline:

 - Major increment when the interface changes in a way that is
   backwards-incompatible, in the sense that a run with the same command and
   the same data would produce a different result (except for non-deterministic
   computations).

 - Minor increment for any other change of the interface, such as additions of
   new functionalities.

 - Patch increment for changes that do not modify the interface (bug fixes,
   minor software and module updates, documentation changes, etc.)
