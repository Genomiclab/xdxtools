rule xenofilteR:
  message:"xenofilteR ..."
  input:
    expand(os.path.join(config["bsmapDir"], "{sample}_{species}.bam"), sample=config["SIDs"],species = config["species"])
  output:
    os.path.join(config["bsmapDir"],"Filtered_bams" ,"{sample}_"+config["graft"]+"_Filtered.bam")
  params:
    filter_root = config["bsmapDir"],
    host = config["host"],
    graft = config["graft"],
    MM_threshold = 6,
    Unmapped_penalty = 8,
    mode = config["Mode"]
  threads:4
  shell:
    """
    Rscript R/xenofilteR.R -d {params.filter_root} \
    --graft {params.graft} \
    --host {params.host} \
    --threads {threads} \
    --MM_threshold {params.MM_threshold} \
    --Unmapped_penalty {params.Unmapped_penalty} \
    --Mode {params.mode}
    
    """
    
