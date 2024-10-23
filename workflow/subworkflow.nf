include { CONCATENATE } from "../modules/concat_fastq.nf"

workflow CONCATENATE_WF {

    ch_input = Channel.fromFilePairs(params.reads).transpose().groupTuple()

    CONCATENATE_WF (ch_input)


}


/*
workflow PRE_MAG {
    CONCATENATE(Channel.fromPath())
    BUILD_DB(Channel.fromPath())

}

workflow POST_MAG {
    KRONA(Channel.fromPath())
    PAVIAN(Channel.fromPath())

}


*/
