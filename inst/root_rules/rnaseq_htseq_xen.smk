rule build_expression_matrix :
  message:"Build expression matrix ..."
  input:
    bam_sorted = lambda wildcards:os.path.join(config["bsmapDir"],"Filtered_bams" , f"{wildcards.sample}_fixed_"+config["graft"]+"_Filtered.bam")
  output:
    os.path.join(config["outDir_mCall"], "{sample}_"+config["graft"]+".txt")
  params:
    rnaseq_gtf = lambda wildcards:config["rnaseq_gtf"][config["species"].index(config["graft"])],
    methylkit = lambda wildcards:os.path.join(config["outDir_mCall"], f"{wildcards.sample}_"+config["graft"]+".txt")
  threads:5
  shell:
    """
      samtools \
      sort -@ {threads} \
      -o {input.bam_sorted} \
      {input.bam_sorted}
      
      samtools index {input.bam_sorted}
    
      htseq-count -f bam -r name -s yes -t exon -i gene_id \
      -m intersection-nonempty \
    {input.bam_sorted} {params.rnaseq_gtf} > {params.methylkit}

    """
   




    
