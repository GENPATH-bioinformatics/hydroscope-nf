process CONCATENATE {
    input: 
    tuple val(name), path fastq //FIXME

    output:
    path fastq //FIXME

    script: 
    """
  
    cat *L00*_R*_001.fastq.gz >> ${name}.fastq.gz

    """

}