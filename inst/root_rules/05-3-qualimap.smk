rule qualimap:
  message: "qualimap ..."
  input:
    sample_bam = lambda wildcards: os.path.join(config["bsmapDir"], f"{wildcards.sample}_{wildcards.species}.bam")
  output:
    os.path.join(config["outdir_qualimap"],"{sample}_{species}", "qualimapReport.html"),
    os.path.join(config["outdir_qualimap"],"{sample}_{species}", "report.pdf")
  params:
    outdir_qualimap = lambda wildcards:os.path.join(config["outdir_qualimap"], f"{wildcards.sample}_{wildcards.species}"),
    java_mem = "40G"
  threads:4
  shell:
    """
    export JAVA_OPTS="-Djava.awt.headless=true"
    qualimap bamqc -bam {input.sample_bam} -outdir {params.outdir_qualimap} -outformat PDF:HTML  --java-mem-size={params.java_mem}
    """
