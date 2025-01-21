rule fastqcAtclean:
  message:"Running FastQC after Trim ..."
  input:
    R1 = os.path.join(config["trimDir"], "{sample}"  + "_val_1.fq.gz"),
    R2 = os.path.join(config["trimDir"], "{sample}" + "_val_2.fq.gz")
  output:
    R1_fastqc_zip = os.path.join(config["qcDir_after"], "{sample}" + "_val_1_fastqc.zip"),
    R1_fastqc_html = os.path.join(config["qcDir_after"], "{sample}" + "_val_1_fastqc.html"),
    R2_fastqc_zip = os.path.join(config["qcDir_after"], "{sample}" + "_val_2_fastqc.zip"),
    R2_fastqc_html = os.path.join(config["qcDir_after"], "{sample}" + "_val_2_fastqc.html")
  params:
    dir=config["qcDir_after"]
  threads: 6
  shell:
    """
    conda run -n fastqc fastqc -o {params.dir} -t {threads} --extract {input.R1} {input.R2}
    
    """
