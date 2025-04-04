rule xenofilteR:
  message:"xenofilteR ..."
  input:
    expand(os.path.join(config["bsmapDir"], "{sample}_{species}_pdx_patch_success"),sample=config["SIDs"],species = config["species"]),
    expand(os.path.join(config["bsmapDir"], "{sample}_fixed_{species}.bam"), sample=config["SIDs"],species = config["species"])
  output:
    os.path.join(config["bsmapDir"],"Filtered_bams" ,"filtered_success.txt")
  params:
    filter_root = config["bsmapDir"],
    host = config["host"],
    graft = config["graft"],
    MM_threshold = (4 if config["Mode"] == "RNASEQ" else 6),
    Unmapped_penalty = 8,
    mode = config["Mode"]
  threads:4
  shell:
    """
    conda run -n base Rscript R/xenofilteR.R -d {params.filter_root} \
    --graft {params.graft} \
    --host {params.host} \
    --threads {threads} \
    --MM_threshold {params.MM_threshold} \
    --Unmapped_penalty {params.Unmapped_penalty} \
    --Mode {params.mode}
    
    touch {params.filter_root}/Filtered_bams/filtered_success.txt
    
    """
    
