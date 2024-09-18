process RENAME {
    input: 

    output: 

    script: 
   """
   read
	while IFS="" read -r p || [ -n "$p" ];
	do 
		fileName=$(echo $p | cut -f2 -d,);
		newName=$(echo $p | cut -f1 -d,);
		echo -e "Renaming ${fileName}\n to $newName\n";
		mv ./${fileName}_con_R1_001.fastq.gz ./${newName}_con_R1_001.fastq.gz
		mv ./${fileName}_con_R2_001.fastq.gz ./${newName}_con_R2_001.fastq.gz
		#rename 's/${fileName}/${newName}/' ./sra_fastq/*
	done
   """
}