rule clubcpgimputecoverage:
  message:"Calculating clubcpg impute coverage before imputation ..."
  input:
    bam_sorted = lambda wildcards:os.path.join(config["bsmapDir"], f"{wildcards.sample}_"+config["fixed"]+config["graft"]+"_Filtered.bam"),
    filter_csv = lambda wildcards:os.path.join(config["clubcpg_coverage_before"], "CompleteBins."+f"{wildcards.sample}_"+config["graft"]+".bam."+f"{wildcards.chr}.filtered.csv")
  output:
    os.path.join(config["clubcpg_coverage_impute"], "CompleteBins."+"{sample}_"+config["graft"]+".bam."+"{chr}.IMPUTED_filter.csv")
  params:
    output_dir = config["clubcpg_coverage_impute"],
    chr = lambda wildcards:f"{wildcards.chr}",
    models = lambda wildcards:os.path.join(config["clubcpg_model"],f"{wildcards.sample}",f"{wildcards.chr}"),
    read1_5 = config["read1_5"],
    read1_3 = config["read1_3"],
    read2_5 = config["read2_5"],
    read2_3 = config["read2_3"],
    filter_output = lambda wildcards:os.path.join(config["clubcpg_coverage_impute"], "CompleteBins."+f"{wildcards.sample}_"+config["graft"]+".bam."+f"{wildcards.chr}.IMPUTED_filter.csv"),
    origin_output = lambda wildcards:os.path.join(config["clubcpg_coverage_impute"], "CompleteBins."+f"{wildcards.sample}_"+config["fixed"]+config["graft"]+".bam."+f"{wildcards.chr}.csv.IMPUTED.csv")
  threads:24
  shell:
    """
    mkdir {params.models}
    samtools index {input.bam_sorted}
    conda run -n clubcpg clugcpg-impute-coverage -a {input.bam_sorted} \
    -c {input.filter_csv} \
    -m {params.models} \
    -o {params.output_dir} \
    -n {threads} -chr {params.chr} \
    --read1_5 {params.read1_5} \
    --read1_3 {params.read1_3} \
    --read2_5 {params.read2_5} \
    --read2_3 {params.read2_3}
    
    cat {params.origin_output} | awk -F "," '$2>=10 && $3>=2' > {params.filter_output}
    
    """
