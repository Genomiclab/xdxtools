rule rnaseq_step2_checker :
  message:"Checking step1 of RNAseq ..."
  input:
    expand(os.path.join(config["bsmapDir"], "{sample}_{species}.bam"), sample= config["SIDs"],species = config["species"]) ,
    expand(os.path.join(config["outdir_qualimap"],"{sample}_{species}","qualimapReport.html") , sample= config["SIDs"],species = config["species"]),
    expand(os.path.join(config["qcDir"],"GCbias","{sample}_{species}", "gc_bias_metrics.txt"),sample= config["SIDs"],species = config["species"]),
    expand(os.path.join(config["qcDir"],"GCbias","{sample}_{species}", "gc_bias_metrics.pdf"),sample= config["SIDs"],species = config["species"]),
    expand(os.path.join(config["qcDir"],"GCbias","{sample}_{species}", "summary_metrics.txt"),sample= config["SIDs"],species = config["species"]),
    os.path.join(config["qc_summary"], "multiqc_report.html") 
  output:
    os.path.join(config["SID_log"], "step2_success.txt")
  params:
    log_marker = os.path.join(config["SID_log"], "step2_success.txt"),
    jobid = config["jobid"] ,
    user_email = config["user_email"]
  threads:5
  shell:
    """
    Rscript R/beaver_mail.R --step 2 --jobid {params.jobid} --send_to {params.user_email}
    touch {params.log_marker}
    """
