rule qcsummary:
  message:"summary QC in the pipeline ..."
  input:
    expand(os.path.join(config["trimDir"], "{sample}_R1.fastq.gz_trimming_report.txt"),sample = config["SIDs"]),
    expand(os.path.join(config["trimDir"], "{sample}_R2.fastq.gz_trimming_report.txt"),sample = config["SIDs"]),
    expand(os.path.join(config["qcDir_after"], "{sample}_val_1_fastqc.zip"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir_after"], "{sample}_val_2_fastqc.zip"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir_after"], "{sample}_val_1_fastqc.html"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir_after"], "{sample}_val_2_fastqc.html"), sample=config["SIDs"]),
    expand(os.path.join(config["qcDir"], "{sample}_seqkit_stat.txt"), sample=config["SIDs"]) ,
    expand(os.path.join(config["bsmapDir"], "{sample}_{species}.bam"), sample=config["SIDs"],species =config["species"]) ,
    expand(os.path.join(config["outdir_qualimap"],"{sample}_{species}","qualimapReport.html") , sample=config["SIDs"],species =config["species"]),
    os.path.join(config["outDir_mCall"], "methrixh5","CpG_coverage.xlsx")
  output:
    os.path.join(config["qc_summary"],"qc_summary.txt")
  params:
    self_config = config["selfconfig"],
    qc_output = config["qc_summary"]
    
  threads:5
  shell:
    """
    Rscript R/QC_summary.R --configfolder {params.self_config} --output_dir {params.qc_output}

    """
    
