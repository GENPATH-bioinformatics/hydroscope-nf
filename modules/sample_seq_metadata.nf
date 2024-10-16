process SAMPLE_SEQ_METADATA {
    input:
    path metadata_csv

    output:
    path write.table 

    script:
    """
    02.sampleSeqMetadata.R \
	 --directory /home/gkibet/bioinformatics/github/metagenomics/data/visualization_WWP2/ \
	 --lib /home/gkibet/R/x86_64-pc-linux-gnu-library/4.3 \
	 --metadata $metadata_csv \
	 --shortdate 20240429
    """
}

workflow TEST {

}
