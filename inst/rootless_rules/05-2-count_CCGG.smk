rule count_ccgg:
  message:"count CCGG ..."
  input:
    R1= lambda wildcards: os.path.join(config["rawDir"], f"{wildcards.sample}_R1.fastq.gz")
  output:
    os.path.join(config["qcDir"], "{sample}"  + "_ccgg_report.txt")
  params:
    report = lambda wildcards: os.path.join(config["qcDir"], f"{wildcards.sample}_ccgg_report.txt")
  threads:6
  shell:
    """
    conda run -n pyfastx python R/Run_count_CCGG.py -I {input.R1} -O {params.report}
    """
