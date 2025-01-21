rule multiqc2summary:
  message: "multiqc ..."
  input:
    expand(os.path.join(config["outdir_qualimap"],"{sample}_{species}","qualimapReport.html") , sample=SIDs,species = species),
    expand(os.path.join(config["outdir_qualimap"],"{sample}_{species}","report.pdf") , sample=SIDs,species = species)
    
  output:
    os.path.join(config["qc_summary"], "multiqc_report.html")
  params:
    outdir = config["qc_summary"],
    readir = config["workDir"]
  threads:4
  shell:
    """
    conda run -n multiqc multiqc {params.readir} -o {params.outdir} -f
    
    """
