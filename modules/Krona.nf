//nf-core/module for krona report from kraken https://github.com/nf-core/modules/tree/master/modules/nf-core/krakentools/kreport2krona 

process KRONA {
    input: 
    path *.kraken2_reports.txt

    output: 
    path *.krona.html, emit: html

    script:
    """
    for taxaFile in $(ls ${INDIR}/results/Taxonomy/kraken2/*/*.kraken2_report.txt)
    do
        fileName=$(dirname $taxaFile)
        src_dir=${fileName##*/}
        echo -e "\nCreating krona.html file from Kraken2.kreport for $src_dir..."
        cd ${fileName}
        cat ${taxaFile} | cut -f 1,3 > ./${src_dir}.krona
        perl ${KRONA}/scripts/ImportTaxonomy.pl -tax ${KRONAdb} \
        -o ./${src_dir}.krona.html ./${src_dir}.krona
        echo -e "Creating krona.html file for ${src_dir} successfully done...\n"
        cd ${INDIR}
    done
    """
}
