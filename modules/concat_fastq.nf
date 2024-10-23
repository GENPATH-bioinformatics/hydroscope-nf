process CONCATENATE {
    input:
    tuple val(name), path (reads)

    output:
    tuple val(name), path ("*.merged.fastq.gz")

    script:
    """
    cat ${reads} >> ${name}.merged.fastq.gz
    """

}

workflow TEST {


    params.reads = "/home/wastewater/ilri-kenya-wastewater-meta-genomic-pathogen-surveillance/hydroscope-nf/_data/minifastq/sample2_{L001,L002}*.fastq.gz"

    ch_input = Channel.fromFilePairs(params.reads)

    groupedReads = ch_input.transpose().groupTuple() //.view()

    CONCATENATE(groupedReads)
}
