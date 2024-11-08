process PAVIAN {
    input: 
    path "read.csv"

    output: 
    tuple path ("write.table"), path ("write.xlsx")

    script: 
    """
    03.pavian.R read.csv write.table write.xlsx 
    """
}

workflow TEST {
    params.kreports = "/home/wastewater/ilri-kenya-wastewater-meta-genomic-pathogen-surveillance/data/visualization_WWP2/kreports/*report.txt.gz"
    ch_input = Channel.fromPath(params.kreports).view()

    PAVIAN (ch_input)
}

/*
// Alternative design
process PAVIAN {
    tag "Pavian analysis"
    
    conda "bioconda::r-pavian=1.2.0"
    container "quay.io/biocontainers/r-pavian:1.2.0--r42hdfd78af_0"

    input:
    path input_file
    
    output:
    path "pavian_results/*"

    script:
    template 'run_pavian.R'
}

include { PAVIAN } from './modules/pavian/main'

workflow {
    input_ch = channel.fromPath('path/to/your/input/file.tsv')
    PAVIAN(input_ch)
}

*/
