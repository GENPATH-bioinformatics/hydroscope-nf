process FASTP {
    input: 
    tuple val(prefix), path(reads)

    output: 
    path fastp

    script: 
    def fread= read[0]
    def rread= read[1]

    """
        fastp \
		--in1 ${fread} \
		--in2 ${rread} \
		--out1 fastp/${prefix}_1.trim.fastq.gz \
		--out2 fastp/${prefix}_2.trim.fastq.gz \
		--json fastp/${prefix}.fastp.json \
		--html fastp/${prefix}.fastp.html \
		--failed_out fastp/${prefix}_fail.fastq.gz \
		--thread 10 \
		--detect_adapter_for_pe \
		--qualified_quality_phred 20 \
		--cut_mean_quality 20 \
		--length_required 15 \
		2> fastp/${prefix}.fastp.log
    """
}

process CARDRGI {
    input: 
    tuple val(prefix), path(astp/${prefix}_1.trim.fastq.gz), path(astp/${prefix}_2.trim.fastq.gz)

    output: 
    path cardrgi 
    
    script: 
    """
        apptainer run ~/bioinformatics/github/metagenomics/scripts/card/rgi_6.0.3--pyha8f3691_0.sif rgi bwt \
		-1 fastp/${prefix}_1.trim.fastq.gz \
		-2 fastp/${prefix}_2.trim.fastq.gz \
		-a kma \
		-n 20 \
		-o rgi/${prefix} \
		--local \
		--include_other_models \
		--include_wildcard

    """
}