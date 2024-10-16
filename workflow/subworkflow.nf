include {concat_fastq}
include {db_build}
include {Krona}
include {pavian}

SAMPLESHEET_CHECK {

}


workflow PRE_MAG {
    CONCATENATE(Channel.fromPath())
    BUILD_DB(Channel.fromPath())

}

workflow POST_MAG {
    KRONA(Channel.fromPath())
    PAVIAN(Channel.fromPath())

}

