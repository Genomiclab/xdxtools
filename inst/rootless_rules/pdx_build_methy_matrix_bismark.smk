rule bismark_methylation_extractor :
  message:"Build beta matrix ..."
  input:
    bam_sorted = lambda wildcards:os.path.join(config["bsmapDir"],"Filtered_bams" ,f"{wildcards.sample}_fixed_"+config["graft"]+"_Filtered.bam")
  output:
    os.path.join(config["outDir_mCall"], "{sample}_nsort.bismark.cov.gz"),
    os.path.join(config["bsmapDir"], "{sample}_nsort.bam")
  params:
    mem_size = "34G",
    mcall_dir = config["outDir_mCall"],
    genomeFile = config["genomeFile"][config["species"].index(config["graft"])],
    bam_nsorted = lambda wildcards:os.path.join(config["bsmapDir"], f"{wildcards.sample}_nsort.bam"),
    bam_nsorted_repaired = lambda wildcards:os.path.join(config["bsmapDir"], f"{wildcards.sample}_repaired_nsort.bam"),
    bam_readnames = lambda wildcards:os.path.join(config["outDir_mCall"], f"{wildcards.sample}_readnames.txt")
  threads:5
  shell:
    """
    
    conda run -n bismark samtools sort  -@ {threads} -n -o {params.bam_nsorted} {input.bam_sorted}
    
    # repair unpaired reads
    conda run -n bismark samtools view {params.bam_nsorted}  | awk '{{print $1}}' | sort > {params.bam_readnames}
    conda run -n base Rscript R/repair_unpaired_reads.R  --readname {params.bam_readnames}
    if [ -e {params.bam_readnames} ]; then
             conda run -n picard picard FilterSamReads I={params.bam_nsorted} O={params.bam_nsorted_repaired} READ_LIST_FILE={params.bam_readnames} FILTER=excludeReadList
             rm {params.bam_nsorted}
             mv {params.bam_nsorted_repaired} {params.bam_nsorted}
      fi
      
    conda run -n bismark bismark_methylation_extractor --paired-end --gzip \
      --output_dir {params.mcall_dir} \
      --comprehensive --merge_non_CpG --bedGraph --multicore {threads} \
      --buffer_size {params.mem_size} \
      {params.bam_nsorted}
    
    """
   




    
