/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { paramsSummaryMap       } from 'plugin/nf-schema'
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_hydroscope-nf_pipeline'
include { PRE_MAG                } from '../subworkflows/local/pre_mag/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow HYDROSCOPE-NF {

    take:
    ch_samplesheet // channel: samplesheet read in from --input

    main:

    ch_versions = Channel.empty()

    //
    // SUBWORKFLOW: Pre-MAG processing
    //
    // TODO: You'll need to create a channel with BAM files from your samplesheet
    // This is an example - adjust according to your samplesheet format
    ch_bam = ch_samplesheet
        .map { meta, fastq_1, fastq_2 ->
            // TODO: Replace this with actual BAM file creation logic
            // This assumes you have BAM files in your samplesheet or create them earlier
            [ meta, file("path/to/your.bam") ]  // Replace with actual BAM file path
        }

    PRE_MAG (
        ch_bam
    )
    ch_versions = ch_versions.mix(PRE_MAG.out.versions)

    //
    // Collate and save software versions
    //
    softwareVersionsToYAML(ch_versions)
        .collectFile(
            storeDir: "${params.outdir}/pipeline_info",
            name:  'hydroscope-nf_software_'  + 'versions.yml',
            sort: true,
            newLine: true
        ).set { ch_collated_versions }


    emit:
    // TODO: Add PRE_MAG outputs to your workflow outputs
    sorted_bam   = PRE_MAG.out.bam        // channel: [ val(meta), [ bam ] ]
    bam_index    = PRE_MAG.out.bai        // channel: [ val(meta), [ bai ] ]
    versions     = ch_versions            // channel: [ path(versions.yml) ]

}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
