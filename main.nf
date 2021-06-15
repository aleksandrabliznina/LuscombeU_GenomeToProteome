#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { LAST_LASTDB                  } from './modules/nf-core/software/last/lastdb/main.nf'     addParams( options: ['args': "${params.lastdb_args}"] )
include { LAST_TRAIN                   } from './modules/nf-core/software/last/train/main.nf'      addParams( options: ['args':"${params.train_args}"] )
include { LAST_LASTAL                  } from './modules/nf-core/software/last/lastal/main.nf'     addParams( options: ['args':"${params.lastal_args}"] )
// include { LAST_SPLIT   as LAST_SPLIT_1 } from './modules/nf-core/software/last/split/main.nf'      addParams( options: ['suffix':'.05.split'] )
include { LAST_MAFCONVERT              } from './modules/nf-core/software/last/mafconvert/main.nf' addParams( options: ['format':'gff'] )

workflow {
// input target
if (params.target) {
    channel
        .from( params.target )
        .map { filename -> file(filename, checkIfExists: true) }
        .map { row _> [ [id:'target'], row ]}
        .set { target }
} else {
    channel
        .fromPath( params.input )
        .splitCsv( header:true, sep:"\t" )
        .map {row -> [ row, file(row.file, checkIfExists: true) ] }
        .set { target }
}

channel
    .value( params.query )
    .map { filename -> file(filename, checkIfExists: true) }
    .map { row -> [ [id:'query'], row] }
    .set { query }

// Align the genomes
    LAST_LASTDB     ( target )
    LAST_TRAIN      ( query,
                      LAST_LASTDB.out.index.map { row -> row[1] } )
    LAST_LASTAL     ( query,
                      LAST_LASTDB.out.index.map { row -> row[1] },
                      LAST_TRAIN.out.param_file.map { row -> row[1] } )
    LAST_MAFCONVERT ( LAST_LASTAL.out.maf )
}
