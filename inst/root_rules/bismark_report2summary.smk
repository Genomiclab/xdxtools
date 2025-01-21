rule bismarkreport:
  message:"building bismark report ..."
  input:
    expand(os.path.join(config["outDir_mCall"], "{sample}_nsort.bismark.cov.gz"),sample = config["SIDs"]),
    graft_align = expand(os.path.join(config["bsmapDir"],config["graft"],"{sample}_val_1_bismark_bt2_pe.bam"),sample = config["SIDs"]),
  output:
    os.path.join(config["bsmapDir"],config["graft"], "{sample}.html")
  params:
    outDir = os.path.join(config["bsmapDir"],config["graft"]),
    alignment_log = lambda wildcards: os.path.join(config["bsmapDir"], config["graft"],f"{wildcards.sample}_val_1_bismark_bt2_PE_report.txt"),
    split_log = lambda wildcards:os.path.join(config["outDir_mCall"],f"{wildcards.sample}_nsort_splitting_report.txt"),
    mbias_log = lambda wildcards:os.path.join(config["outDir_mCall"],f"{wildcards.sample}_nsort.M-bias.txt"),
    samplename = lambda wildcards:f"{wildcards.sample}.html",
    nucleotide_log = lambda wildcards:os.path.join(config["bsmapDir"],config["graft"],f"{wildcards.sample}_val_1_bismark_bt2_pe.nucleotide_stats.txt")
    
  threads:10
  shell:
    """
    bismark2report --dir {params.outDir} \
    --output {params.samplename} \
    --alignment_report {params.alignment_log} \
    --splitting_report {params.split_log} \
    --mbias_report {params.mbias_log} \
    --nucleotide_report {params.nucleotide_log}
    
    """
