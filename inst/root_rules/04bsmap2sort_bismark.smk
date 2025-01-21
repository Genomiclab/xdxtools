rule bsmap2sort4homo:
  message: "bsmap ..."
  input:
    trim_R1 = lambda wildcards: os.path.join(config["trimDir"], f"{wildcards.sample}_val_1.fq.gz"),
    trim_R2 = lambda wildcards: os.path.join(config["trimDir"], f"{wildcards.sample}_val_2.fq.gz")
  output:
    os.path.join(config["bsmapDir"], "{sample}_{species}" + ".bam")
  params:
    bsmapDir = config["bsmapDir"],
    bsmapDir_species = lambda wildcards: os.path.join(config["bsmapDir"],f"{wildcards.species}"),
    bam_aligned = lambda wildcards: os.path.join(config["bsmapDir"],f"{wildcards.species}", f"{wildcards.sample}_val_1_bismark_bt2_pe.bam"),
    bam_sorted = lambda wildcards:os.path.join(config["bsmapDir"], f"{wildcards.sample}_"+f"{wildcards.species}"+".bam"),
    bamTmp = lambda wildcards:os.path.join(config["bsmapDir"],"tmp",f"{wildcards.species}"),
    genomeFile = lambda wildcards:config["genomeFile"][config["species"].index(wildcards.species)]
  threads: 8
  shell:
    """
    bismark --genome {params.genomeFile} --nucleotide_coverage --parallel {threads} -1 {input.trim_R1} -2 {input.trim_R2} -o {params.bsmapDir_species}  --temp_dir {params.bamTmp}
    
    samtools sort -@ {threads} -o {params.bam_sorted} {params.bam_aligned}
    
    samtools index -@ {threads} -b {params.bam_sorted}
    
    #rm -f {params.bam_aligned}
    
    """
