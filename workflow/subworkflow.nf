include { CONCATENATE } from "../modules/concat_fastq.nf"
include {BUILD_DB} from "../modules/db_build.nf"
include {KRONA} from "../modules/krona.nf"
include {PAVIAN} from "../modules/pavian.nf"

workflow CONCATENATE_WF {

	main:
	    ch_input = Channel.fromPath(params.samplesheet).splitCsv(skip : 1).map {it -> [it.take(1).first(), it.drop(1)] }

	    CONCATENATE (ch_input)
}

workflow BD_BUILD_WF {
    main: 
        ch_input = Channel.fromPath(params.sequences)
        BUILD_DB (ch_input)
}

workflow KRONA {
    
    main: 
        ch_input = Channel.fromPath(params.kreport)

        KRONA (ch_input)
}

worKflow PAVIAN {
    
    main:
        ch_input = Channel.fromPath(params.kreport)

        PAVIAN (ch_input)
}

workflow BD_BUILD_WF {
    main: 
        ch_input = Channel.fromPath(params.sequences)
        BUILD_DB (ch_input)
}