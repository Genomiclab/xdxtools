rule rnaseqmappingbowtie:
  message: "RNAseq mapping ..."
  input:
    trim_R1 = lambda wildcards: os.path.join(config["trimDir"], f"{wildcards.sample}_val_1.fq.gz"),
    trim_R2 = lambda wildcards: os.path.join(config["trimDir"], f"{wildcards.sample}_val_2.fq.gz")
  output:
    os.path.join(config["bsmapDir"], "{sample}_{species}" + ".bam")
  params:
    bsmapDir = config["bsmapDir"],
    tempdir = lambda wildcards: os.path.join(config["bsmapDir"],"tmp", f"{wildcards.sample}"),
    sam_aligned = lambda wildcards: os.path.join(config["bsmapDir"],f"{wildcards.species}", f"{wildcards.sample}_aligned.sam"),
    bam_aligned = lambda wildcards: os.path.join(config["bsmapDir"],f"{wildcards.species}", f"{wildcards.sample}Aligned.sortedByCoord.out.bam"),
    bam_aligned_prefix = lambda wildcards: os.path.join(config["bsmapDir"],f"{wildcards.species}", f"{wildcards.sample}"),
    bam_sorted = lambda wildcards:os.path.join(config["bsmapDir"], f"{wildcards.sample}_"+f"{wildcards.species}"+".bam"),
    rnaseq_ref = lambda wildcards:config["rnaseq_ref"][config["species"].index(wildcards.species)]
  threads: 40
  shell:
    """
    conda run -n star STAR --runThreadN {threads} \
    --readFilesCommand zcat \
    --quantMode GeneCounts \
    --genomeDir {params.rnaseq_ref} \
    --readFilesIn {input.trim_R1} {input.trim_R2} \
    --twopassMode Basic \
    --outSAMunmapped None \
    --outSAMtype BAM SortedByCoordinate \
    --outSAMattributes NH HI AS nM NM MD \
    --outFileNamePrefix  {params.bam_aligned_prefix} 
    
    samtools sort -@ {threads} -o {params.bam_sorted} {params.bam_aligned}
    
    samtools index {params.bam_sorted}
    
    rm -f {params.bam_aligned}
    
    """
