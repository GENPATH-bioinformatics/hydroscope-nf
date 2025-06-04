include { CAT_FASTQ } from './../../../modules/nf-core/cat/fastq/main.nf'


workflow PRE_MAG {
    main:

    ch_versions = Channel.empty()

    if (params.concat ) {
        // Channel for joining mapped & unmapped fastq
        reads_to_concat = Channel.fromFilePairs(params.reads)
                            .transpose().groupTuple()

        // Concatenate Mapped_R1 with Unmapped_R1 and Mapped_R2 with Unmapped_R2
        CAT_FASTQ(reads_to_concat)

        // Gather versions of all tools used
        ch_versions = ch_versions.mix(CAT_FASTQ.out.versions)
    }


    emit:
    versions         = ch_versions
}

