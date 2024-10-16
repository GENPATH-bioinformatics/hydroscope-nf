process CONCATENATE {
    input: 
    tuple val(name), path (reads) 

    output:
    tuple val(name), path ("**_R{1,2}.merged.fastq.gz")

    script: 
    """
  
    cat *L00*_R1_001.fastq.gz >> ${name}_R1.merged.fastq.gz

    cat *L00*_R2_001.fastq.gz >> ${name}_R2.merged.fastq.gz


    """

}

workflow TEST {
    inputReads = Channel.fromFilePairs("/home/wastewater/ilri-kenya-wastewater-meta-genomic-pathogen-surveillance/hydroscope-nf/_data/minifastq/sample2_{L001,L002}*.fastq.gz")

    groupedReads = inputReads.transpose().groupTuple() //.view()

    CONCATENATE(groupedReads)
}
