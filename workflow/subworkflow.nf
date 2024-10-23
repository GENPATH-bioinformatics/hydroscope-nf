include { CONCATENATE } from "../modules/concat_fastq.nf"


workflow CONCATENATE_WF {

	main:
	    ch_input = Channel.fromPath(params.samplesheet).splitCsv(skip : 1).map {it -> [it.take(1).first(), it.drop(1)] }

	    CONCATENATE (ch_input)


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
