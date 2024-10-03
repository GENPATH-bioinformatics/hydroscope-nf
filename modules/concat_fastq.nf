process CONCATENATE {
    input: 
    tuple val(name), path (fastq) 

    output:
    tuple val(name), path ("*_R{1,2}.merged.fastq.gz")

    script: 
    """
  
    cat *L00*_R1_001.fastq.gz >> ${name}_R1.merged.fastq.gz

    cat *L00*_R2_001.fastq.gz >> ${name}_R2.merged.fastq.gz


    """

}

workflow TEST {
    // this:Channel.fromPath()
    // or this: CONCATENATE(Channel.fromPath(0))
}