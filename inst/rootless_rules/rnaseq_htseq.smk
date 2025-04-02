rule build_expression_matrix :
  message:"Build expression matrix ..."
  input:
    bam_sorted = lambda wildcards:os.path.join(config["bsmapDir"], f"{wildcards.sample}_"+f"{wildcards.species}"+".bam")
  output:
    os.path.join(config["outDir_mCall"], "{sample}_{species}.txt")
  params:
    rnaseq_gtf = lambda wildcards:config["rnaseq_gtf"][config["species"].index(wildcards.species)],
    methylkit = lambda wildcards:os.path.join(config["outDir_mCall"], f"{wildcards.sample}_"+f"{wildcards.species}"+".txt")
  threads:5
  shell:
    """
    conda run -n htseq htseq-count -f bam -r name -s yes -t exon -i gene_id -m intersection-nonempty \
    {input.bam_sorted} {params.rnaseq_gtf} > {params.methylkit}

    """
   




    
