process BUILD_DB {

    input:
    path "fasta"

    output:
    path OUTDIR 

    script: 
    """
    mkdir -p ${OUTDIR}/{taxonomy, library, centrifugedb}
    echo -e "\\tStep 4: Building non-redundant nt database from NCBI data..."
    ${centrifugeBuild} -p 4 
        --bmax 1342177280
        --conversion-table ${OUTDIR}/accession2taxid_nucl.map
        --taxonomy-tree ${OUTDIR}/taxonomy/nodes.dmp
        --name-table ${OUTDIR}/taxonomy/names.dmp
        ${OUTDIR}/library/nt.fa${OUTDIR}/centrifugedb/nt
     && echo -e "\\tStep 4 successfully completed..." 
    || echo -e "\\tBuilding the centrifuge database from nt database NOT successful..."
    """
}

workflow TEST {
    params.sequences = "/home/wastewater/ilri-kenya-wastewater-meta-genomic-pathogen-surveillance/hydroscope-nf/_data/minifastq/*.fastq.gz"
    ch_input = Channel.fromPath(params.sequences)
    BUILD_DB(ch_input)
}