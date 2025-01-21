rule collectGCbias:
  message: "collectGCbias ..."
  input:
    sample_bam = lambda wildcards: os.path.join(config["bsmapDir"], f"{wildcards.sample}_{wildcards.species}.bam")
  output:
    os.path.join(config["qcDir"],"GCbias","{sample}_{species}", "gc_bias_metrics.txt"),
    os.path.join(config["qcDir"],"GCbias","{sample}_{species}", "gc_bias_metrics.pdf"),
    os.path.join(config["qcDir"],"GCbias","{sample}_{species}", "summary_metrics.txt")
  params:
    outdir_gcbias = lambda wildcards:os.path.join(config["qcDir"],"GCbias",f"{wildcards.sample}_{wildcards.species}"),
    fasta = lambda wildcards:config["gnome_fasta"][config["species"].index(wildcards.species)],
    gc_txt = lambda wildcards:os.path.join(config["qcDir"],"GCbias",f"{wildcards.sample}_{wildcards.species}","gc_bias_metrics.txt"),
    gc_pdf = lambda wildcards:os.path.join(config["qcDir"],"GCbias",f"{wildcards.sample}_{wildcards.species}","gc_bias_metrics.pdf"),
    gc_sum = lambda wildcards:os.path.join(config["qcDir"],"GCbias",f"{wildcards.sample}_{wildcards.species}","summary_metrics.txt")
  threads:4
  shell:
    """
    java -jar /picard/picard.jar CollectGcBiasMetrics \
      I={input.sample_bam} \
      O={params.gc_txt}  \
      CHART={params.gc_pdf}  \
      S={params.gc_sum}  \
      R={params.fasta} 
    """
