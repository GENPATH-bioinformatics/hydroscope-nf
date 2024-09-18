process SAMPLESEQ {
    input:
    file read.xlsx

    output:
    file write.table 

    script:
    """
    02.sampleSeqMetadata.R read.xlsx write.table
    """
}