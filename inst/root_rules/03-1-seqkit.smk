rule seqkit:
  message:"seqkit ..."
  input:
    fastq_R1 = lambda wildcards: os.path.join(config["rawDir"], f"{wildcards.sample}_R1.fastq.gz"),
    fastq_R2 = lambda wildcards: os.path.join(config["rawDir"], f"{wildcards.sample}_R2.fastq.gz"),
    trim_R1 = lambda wildcards: os.path.join(config["trimDir"], f"{wildcards.sample}_val_1.fq.gz"),
    trim_R2 = lambda wildcards: os.path.join(config["trimDir"], f"{wildcards.sample}_val_2.fq.gz")
  output:
    os.path.join(config["qcDir"], "{sample}_seqkit_stat.txt")
  params:
    stat = lambda wildcards:os.path.join(config["qcDir"], f"{wildcards.sample}_seqkit_stat.txt")
  threads:6
  shell:
    """
    seqkit stat  -a -j {threads} -T -b {input.fastq_R1} {input.fastq_R2} {input.trim_R1} {input.trim_R2} > {params.stat}
    """
