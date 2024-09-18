process CENTRIFUGE {

    input:
    path fasta // change me 

    outout:
    path OUTDIR // change me 

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
    if [ $? -eq ]; then 
        echo -e "\\tStep 4 successfully completed..."
    esle 
        echo -e "\\tBuilding the centrifuge dataase from nt database NOT siccessful..."
    fi
    """
}