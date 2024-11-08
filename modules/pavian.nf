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