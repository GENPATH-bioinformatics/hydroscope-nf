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