rule rnaseq_step2_checker :
  message:"Checking step1 of RNAseq ..."
  input:
    expand(os.path.join(config["bsmapDir"], "{sample}_{species}.bam"), sample=config["SIDs"],species = config["species"]) ,
    expand(os.path.join(config["outdir_qualimap"],"{sample}_{species}","qualimapReport.html") , sample=config["SIDs"],species = config["species"]) ,
    expand(os.path.join(config["outDir_mCall"], "{sample}_{species}"+".txt"), sample=config["SIDs"],species = config["species"]),
    os.path.join(config["outDir_betaM"], "matrix_count.txt"),
    os.path.join(config["outDir_betaM"], "matrix_norm.txt") 
  output:
    os.path.join(config["SID_log"], "step2_success.txt")
  params:
    log_marker = os.path.join(config["SID_log"], "step2_success.txt"),
    jobid = config["jobid"],
    user_email = config["user_email"]
  threads:5
  shell:
    """
    conda run -n base Rscript R/beaver_mail.R --step 2 --jobid {params.jobid} --send_to {params.user_email}
    touch {params.log_marker}
    """
