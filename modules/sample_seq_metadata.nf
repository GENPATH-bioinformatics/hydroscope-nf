process SAMPLE_SEQ_METADATA {
    input:
    path metadata_csv

    output:
    path sample_metadata

    script:
    """
     02.sampleSeqMetadata.R \
	--directory ${metadata_csv} \
    --lib ${metadata_csv} \
    --metadata ${metadata_csv} \
    --shortdate 20241016 \
    read.xlsx write.xlsx
    """  
}

workflow TEST {
metadata = Channel.of("/home/wastewater/ilri-kenya-wastewater-meta-genomic-pathogen-surveillance/hydroscope-nf/_data/fastqs/metadata")
SAMPLE_SEQ_METADATA(metadata)
}
