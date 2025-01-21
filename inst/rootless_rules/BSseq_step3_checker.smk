rule rnaseq_step3_checker :
  message:"Checking step1 of RNAseq ..."
  input:
    expand(os.path.join(config["outDir_mCall"], "{sample}_nsort.bismark.cov.gz"),sample = config["SIDs"]),
    expand(os.path.join(config["bsmapDir"], "{sample}_nsort.bam"),sample =config["SIDs"] ),
    os.path.join(config["outDir_mCall"], "methrixh5","assays.h5"),
    os.path.join(config["outDir_mCall"], "methrixh5","se.rds"),
    os.path.join(config["outDir_mCall"], "methrixh5","bsseq.RDS"),
    os.path.join(config["bsmapDir"],config["graft"], "bismark_summary_report.html"),
    os.path.join(config["qc_summary"],"qc_summary.txt") 
  output:
    os.path.join(config["SID_log"], "step3_success.txt")
  params:
    log_marker = os.path.join(config["SID_log"], "step3_success.txt"),
    jobid = config["jobid"],
    user_email = config["user_email"]
  threads:5
  shell:
    """
    conda run -n base Rscript R/beaver_mail.R --step 3 --jobid {params.jobid} --send_to {params.user_email}
    touch {params.log_marker}
    """
