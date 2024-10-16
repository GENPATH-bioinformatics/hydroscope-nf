//nf-core/module for krona report from kraken https://github.com/nf-core/modules/tree/master/modules/nf-core/krakentools/kreport2krona 

process KRONA {
    input: 
    tuple val(sample) path(reports)

    output: 
    path "*.krona.html"

    script:
    '''
    for taxaFile in results/Taxonomy/kraken2/*/*.kraken2_report.txt
    do
        echo -e "\nCreating krona.html file from Kraken2.kreport "
        cat *.kraken2_report.txt | cut -f 1,3 > ./*.krona
        perl ${KRONA}/scripts/ImportTaxonomy.pl -tax ${KRONAdb} \
        -o ./*.krona.html ./*.krona
        echo -e "Creating krona.html file successfully done...\n"
    done
    '''
}
