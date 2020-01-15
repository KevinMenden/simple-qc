#!/usr/bin/env nextflow
/*
========================================================================================
                         simple-qc
========================================================================================

----------------------------------------------------------------------------------------
*/



/*
 * SET UP CONFIGURATION VARIABLES
 */



/*
 * Create a channel for input read files
 */


Channel
    .fromFilePairs( params.reads, size: params.singleEnd ? 1 : 2 )
    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.reads}\nNB: Path needs to be enclosed in quotes!\nNB: Path requires at least one * wildcard!\nIf this is single-end data, please specify --singleEnd on the command line." }
    .into { read_files_fastqc }


/**
 * STEP 1 - Run FastQC
 */


process fastqc {
    tag "$name"
    publishDir "${params.outdir}/fastqc", mode: 'copy'

    input:
    set val(name), file(reads) from read_files_fastqc


    output:
    file '*' into fastqc_result

    script:

    """
    fastqc $reads
    """
}

/*
 * Completion e-mail notification
 */
workflow.onComplete {
 log.info "Pipeline Complete"
}
