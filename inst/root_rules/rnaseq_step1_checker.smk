rule rnaseq_step1_checker :
  message:"Checking step1 of RNAseq ..."
  input:
    expand(os.path.join(config["qcDir_before"], "{sample}_R1_fastqc.zip"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir_before"], "{sample}_R2_fastqc.zip"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir_before"], "{sample}_R1_fastqc.html"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir_before"], "{sample}_R2_fastqc.html"), sample=config["SIDs"]),
    expand(os.path.join(config["trimDir"], "{sample}_val_1.fq.gz"),sample = config["SIDs"]),
    expand(os.path.join(config["trimDir"], "{sample}_val_2.fq.gz"),sample = config["SIDs"]),
    expand(os.path.join(config["trimDir"], "{sample}_R1.fastq.gz_trimming_report.txt"),sample = config["SIDs"]),
    expand(os.path.join(config["trimDir"], "{sample}_R2.fastq.gz_trimming_report.txt"),sample = config["SIDs"]),
    expand(os.path.join(config["qcDir_after"], "{sample}_val_1_fastqc.zip"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir_after"], "{sample}_val_2_fastqc.zip"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir_after"], "{sample}_val_1_fastqc.html"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir_after"], "{sample}_val_2_fastqc.html"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir"], "{sample}_seqkit_stat.txt"), sample=config["SIDs"]) 
  output:
    os.path.join(config["SID_log"], "step1_success.txt")
  params:
    log_marker = os.path.join(config["SID_log"], "step1_success.txt"),
    jobid = config["jobid"],
    user_email = config["user_email"]
  threads:5
  shell:
    """
    Rscript R/beaver_mail.R --step 1 --jobid {params.jobid} --send_to {params.user_email} 
    touch {params.log_marker}
    """
