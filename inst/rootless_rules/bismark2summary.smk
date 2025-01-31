rule bismarksummary:
  message:"building bismark summary..."
  input:
    graft_align = expand(os.path.join(config["bsmapDir"],config["graft"],"{sample}_val_1_bismark_bt2_pe.bam"),sample = config["SIDs"]),
    bismark_report = expand(os.path.join(config["bsmapDir"],config["graft"],"{sample}.html"),sample = config["SIDs"])
  output:
    os.path.join(config["bsmapDir"],config["graft"], "bismark_summary_report.html")
  params:
    rundir = os.path.join(config["bsmapDir"],config["graft"]),
    graft_align = expand("{sample}_val_1_bismark_bt2_pe.bam",sample = config["SIDs"])
  threads:10
  shell:
    """
    cd {params.rundir} && conda run -n bismark bismark2summary {params.graft_align} 
    
    """
