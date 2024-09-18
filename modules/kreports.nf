process KREPORTS [
    input:
    path read.csv 

    output:
    tuple path(write.table) path(write.xlsx) 

    script: 
    """
    04.kreportsSummary.R read.csv write.table write.xlsx
    """
]